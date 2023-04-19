module Cfe
  class EmploymentIncomePayloadService < BaseService
    def call
      return unless relevant_form?(:employment)

      employment_form = EmploymentForm.from_session(@session_data)
      applicant_form = ApplicantForm.from_session(@session_data)
      employment_income = CfeParamBuilders::Employments.call(employment_form, applicant_form)

      payload[:employment_income] = employment_income
    end
  end
end
