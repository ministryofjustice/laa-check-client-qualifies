class ControlledWorkDocumentPopulationService
  class << self
    def call(session_data, document_choice_form)
      Dir.mktmpdir do |dir|
        file_name = "#{dir}/output-form.pdf"
        pdftk = PdfForms.new(`which pdftk`.chomp)
        pdftk.fill_form template_path(document_choice_form), file_name, values(session_data, document_choice_form)
        yield File.read(file_name).force_encoding("BINARY")
      end
    end

    def template_path(document_choice_form)
      # TODO: Support other form types
      raise "#{document_choice_form.form_type} not yet supported" unless document_choice_form.form_type == "cw1"

      Rails.root.join("lib/cw1-form.pdf")
    end

    def values(_session_data, _document_choice_form)
      # TODO: Populate real data dynamically
      { "undefined_88": "This field is called undefined_88" }
    end
  end
end
