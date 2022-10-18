module Flow
  class CaseDetailsHandler
    class << self
      def model(session_data, _index)
        ProceedingTypeForm.new session_data.slice(*ProceedingTypeForm::ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data, _index)
        ProceedingTypeForm.new(params.fetch(:proceeding_type_form, {})
                                 .permit(*ProceedingTypeForm::ATTRIBUTES))
      end

      def save_data(cfe_connection, estimate_id, form, _session_data)
        cfe_connection.create_proceeding_type(estimate_id, form.proceeding_type)
      end
    end
  end
end
