module Flow
  class PartnerHandler < GenericHandler
    def model_from_session(session_data)
      session_keys = @form_class::ATTRIBUTES.map(&:to_s).map { "partner_#{_1}" }
      session_attributes = session_data.slice(*session_keys)
      transformed_session_attributes = session_attributes.transform_keys { _1.gsub("partner_", "") }
      partner_form_class.new(transformed_session_attributes).tap { modify(_1, session_data) }
    end

    def model_from_params(params, session_data)
      form_params = params.fetch(partner_form_class_name.underscore, {})
      partner_form_class.new(form_params.permit(*@form_class::ATTRIBUTES)).tap { modify(_1, session_data) }
    end

    def extract_attributes(form)
      form.attributes.transform_keys { "partner_#{_1}" }
    end

    # Ensure that the model's class name starts with 'Partner' so that it gets its own
    # key for validation error i18n.
    def partner_form_class
      if Object.const_defined?(partner_form_class_name)
        partner_form_class_name.constantize
      else
        Object.const_set(partner_form_class_name, Class.new(@form_class))
      end
    end

    def partner_form_class_name
      @partner_form_class_name ||= "Partner#{@form_class.name}"
    end
  end
end
