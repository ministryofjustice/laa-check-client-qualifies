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
      pdf_data = Grover.new(html_string, **GROVER_OPTIONS.merge(display_url:)).to_pdf
      pdf_data.force_encoding("UTF-8")
      yield pdf_data
    end
  end
end
