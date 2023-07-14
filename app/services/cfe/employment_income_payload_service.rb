module Cfe
  class EmploymentIncomePayloadService < BaseService
    def call
      if FeatureFlags.enabled?(:self_employed, @session_data)
        income_payload
      else
        employment_payload
      end
    end

    def income_payload
      return unless relevant_form?(:income)

      income_form = IncomeForm.from_session(@session_data)
      payload[:employment_details] = CfeParamBuilders::Employment.call(income_form)
      payload[:self_employment_details] = CfeParamBuilders::SelfEmployment.call(income_form)
    end

    def employment_payload
      return unless relevant_form?(:employment)

      employment_form = instantiate_form(EmploymentForm)
      applicant_form = instantiate_form(ApplicantForm)
      employment_income = CfeParamBuilders::EmploymentIncomes.call(employment_form, applicant_form)

      payload[:employment_income] = employment_income
    end
  end
end
