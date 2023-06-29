module Cfe
  class EmploymentIncomePayloadService < BaseService
    def call
      return unless relevant_form?(:employment)

      employment_form = instantiate_form(EmploymentForm)
      applicant_form = instantiate_form(ApplicantForm)
      employment_income = CfeParamBuilders::Employments.call(employment_form, applicant_form)

      payload[:employment_income] = employment_income
    end
  end
end
