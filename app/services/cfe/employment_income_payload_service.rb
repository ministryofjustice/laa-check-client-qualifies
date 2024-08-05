module Cfe
  class EmploymentIncomePayloadService
    class << self
      def call(session_data, payload, completed_steps)
        return unless BaseService.completed_form?(completed_steps, :income)

        # This appears to trigger a latent defect where CFE is called w/o employment details if it is changed
        # may well be fixed by EL-1668
        # return if check.skip_income_questions? || !check.employed?

        income_form = IncomeForm.model_from_session(session_data)
        payload[:employment_details] = CfeParamBuilders::Employment.call(income_form)
        payload[:self_employment_details] = CfeParamBuilders::SelfEmployment.call(income_form)
      end
    end
  end
end
