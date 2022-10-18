module Flow
  class CaseDetailsHandler
    class << self
      def model(session_data)
        ProceedingTypeForm.new session_data.slice(*ProceedingTypeForm::ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        ProceedingTypeForm.new(params.fetch(:proceeding_type_form, {})
                                 .permit(*ProceedingTypeForm::ATTRIBUTES))
      end
    end
  end
end
