module Flow
  class GenericHandler
    def initialize(form_class)
      @form_class = form_class
    end

    def model_from_session(session_data)
      @form_class.new(session_data.slice(*@form_class::ATTRIBUTES.map(&:to_s))).tap { modify(_1, session_data) }
    end

    def model_from_params(params, session_data)
      relevant_params = params.fetch(@form_class.name.underscore, {}).permit(*@form_class::ATTRIBUTES)
      @form_class.new(relevant_params).tap { modify(_1, session_data) }
    end

    def modify(_form, _session_data); end

    def extract_attributes(form)
      form.attributes
    end
  end
end
