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
    require "prawn"

    def with_pdf_data_from_html_string(html_string, display_url)
      Tempfile.open("initial_pdf", binmode: true) do |initial_pdf|
        pdf_data = Grover.new(html_string, **GROVER_OPTIONS.merge(display_url:)).to_pdf
        initial_pdf.binmode
        initial_pdf.write(pdf_data)
        initial_pdf.rewind

        pdf = Prawn::Document.new(template: initial_pdf.path)
        pdf.state.store.root.data[:Lang] = "en-GB"

        Tempfile.open("modified_pdf", binmode: true) do |modified_pdf|
          modified_pdf.binmode
          pdf.render_file(modified_pdf.path)
          modified_pdf.rewind

          yield modified_pdf.read
        end
      end
    end
  end
end
