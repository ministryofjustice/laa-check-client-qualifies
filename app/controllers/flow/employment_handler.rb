module Flow
  class EmploymentHandler
    class << self
      def model(session_data)
        EmploymentForm.new session_data.slice(*EmploymentForm::EMPLOYMENT_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        EmploymentForm.new(params.require(:employment_form)
          .permit(*EmploymentForm::EMPLOYMENT_ATTRIBUTES))
      end
    end
  end
end
