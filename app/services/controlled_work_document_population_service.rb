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
      check = Check.new(session_data)
      calculation_result = session_data["api_response"]
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/#{form_type}.yml")).with_indifferent_access
      mappings[:mappings].map { [_1[:name], convert(_1, check, calculation_result)] }.to_h
    end

    def convert(mapping, check, calculation_result)
      case mapping[:type]
      when "checkbox"
        mapping[:checked_value] if value(mapping, check, calculation_result)
      when "text"
        value(mapping, check, calculation_result)
      end
    end

    def value(mapping, check, calculation_result)
      case mapping[:source]
      when "answers"
        check.send(mapping[:attribute])
      when "result"
        calculation_result.dig(*mapping[:attribute].split("."))
      when "static"
        mapping[:name]
      end
    end
  end
end
