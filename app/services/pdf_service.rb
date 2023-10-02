class PdfService
  GROVER_OPTIONS = {
    format: "A4",
    margin: {
      top: "2cm",
      bottom: "2cm",
      left: "1cm",
      right: "1cm",
    },
    prefer_css_page_size: true,
    print_background: true,
    viewport: {
      width: 2400,
      height: 4800,
    },
    emulate_media: "screen",
    launch_args: ["--font-render-hinting=medium", "--no-sandbox", "--force-renderer-accessibility"],
  }.freeze

  class << self
    def with_pdf_data_from_html_string(html_string, display_url)
      Tempfile.open("initial_pdf") do |initial_pdf|
        pdf_data = Grover.new(html_string, **GROVER_OPTIONS.merge(display_url:)).to_pdf
        initial_pdf.write(pdf_data.force_encoding("UTF-8"))
        initial_pdf.rewind

        # Grover doesn't know how to set language metadata in the PDF 'Catalog'
        # (see https://github.com/Studiosity/grover/issues/190#issuecomment-1517122470)
        # so we do it manually here
        editable = HexaPDF::Document.open(initial_pdf.path)
        editable.catalog.value[:Lang] = "en-GB"

        Tempfile.open("modified_pdf") do |modified_pdf|
          editable.write(modified_pdf.path)
          modified_pdf.rewind

          yield modified_pdf.read
        end
      end
    end
  end
end
