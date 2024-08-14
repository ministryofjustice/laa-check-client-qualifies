module Cfe
  class EmploymentIncomePayloadService
    class << self
      def call(session_data, payload)
        check = Check.new session_data
        return if check.skip_income_questions? || !check.employed?

        income_form = IncomeForm.model_from_session(session_data)
        payload[:employment_details] = CfeParamBuilders::Employment.call(income_form)
        payload[:self_employment_details] = CfeParamBuilders::SelfEmployment.call(income_form)
      end
    end
  end
end
