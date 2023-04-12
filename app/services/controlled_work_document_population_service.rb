class ControlledWorkDocumentPopulationService
  class << self
    def call(session_data, form_type)
      Dir.mktmpdir do |dir|
        file_name = "#{dir}/output-form.pdf"
        pdftk = PdfForms.new(`which pdftk`.chomp)
        pdftk.fill_form template_path(form_type), file_name, values(session_data, form_type)
        yield File.read(file_name).force_encoding("BINARY")
      end
    end

    TEMPLATES = {
      "cw1" => "lib/cw1-form.pdf",
    }.freeze

    def template_path(form_type)
      Rails.root.join(TEMPLATES.fetch(form_type))
    end

    def values(session_data, form_type)
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/#{form_type}.yml")).map(&:with_indifferent_access)
      ControlledWorkDocumentValueMappingService.call(session_data, mappings)
    end
  end
end
