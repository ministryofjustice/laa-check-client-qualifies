module Flow
  class AssetHandler < GenericHandler
    def model_from_params(params, _session_data)
      relevant_params = params.fetch(@form_class.name.underscore, {}).permit(*@form_class::ATTRIBUTES, in_dispute: [])
      @form_class.new(relevant_params)
    end
  end
end
