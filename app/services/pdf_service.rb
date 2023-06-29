class PdfService
  GROVER_OPTIONS = {
    format: "A4",
    margin: {
      top: "2cm",
      bottom: "2cm",
      left: "1cm",
      right: "1cm",
    },
    emulate_media: "screen",
    launch_args: ["--font-render-hinting=medium", "--no-sandbox"],
    execute_script: "document.querySelectorAll('button').forEach(el => el.style.display = 'none')",
  }.freeze

  class << self
    def with_pdf_data_from_html_string(html_string, display_url)
      Tempfile.open("pdf") do |file|
        pdf_data = Grover.new(html_string, **GROVER_OPTIONS.merge(display_url:)).to_pdf
        file.write(pdf_data.force_encoding("UTF-8"))
        file.rewind

        # Grover doesn't set the language metadata so we adjust that manually
        `exiftool #{file.path} -Language="en-GB"`

        # To pick up the change in metadata we need to re-open the file
        File.open(file.path) do |reopened_file|
          yield reopened_file.read
        end
      end
    end
  end
end
