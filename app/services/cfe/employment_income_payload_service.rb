module Cfe
  class EmploymentIncomePayloadService < BaseService
    def call
      return unless relevant_form?(:income)

      income_form = IncomeForm.from_session(@session_data)
      payload[:employment_details] = CfeParamBuilders::Employment.call(income_form)
      payload[:self_employment_details] = CfeParamBuilders::SelfEmployment.call(income_form)
    end
  end
end
