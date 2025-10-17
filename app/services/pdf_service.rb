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
      width: 1200,  # Reduced from 2400 to improve performance
      height: 1600, # Reduced from 4800 to improve performance
    },
    emulate_media: "screen",
    wait_until: "networkidle0", # Wait for network to be idle before generating PDF
    timeout: 60_000, # Increased from 30 to 60 seconds for CI environments
    launch_args: [
      "--font-render-hinting=medium",
      "--no-sandbox",
      "--disable-dev-shm-usage",
      "--disable-gpu",
      "--disable-software-rasterizer",
      "--disable-background-timer-throttling",
      "--disable-renderer-backgrounding",
      "--disable-features=TranslateUI",
      "--no-first-run",
      "--disable-web-security", # Allow cross-origin requests
      "--disable-features=VizDisplayCompositor",
    ],
  }.freeze

  class << self
    def with_pdf_data_from_html_string(html_string, display_url)
      pdf_data = Grover.new(html_string, **GROVER_OPTIONS.merge(display_url:)).to_pdf
      pdf_data.force_encoding("UTF-8")
      yield pdf_data
    end
  end
end
