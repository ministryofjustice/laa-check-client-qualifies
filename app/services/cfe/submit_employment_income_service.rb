module Cfe
  class SubmitEmploymentIncomeService < BaseService
    def call(cfe_assessment_id)
      return unless relevant_form?(:employment)

      employment_form = EmploymentForm.from_session(@session_data)
      applicant_form = ApplicantForm.from_session(@session_data)
      employment_data = CfeParamBuilders::Employments.call(employment_form, applicant_form)

      cfe_connection.create_employments(cfe_assessment_id, employment_data)
    end
  end
end
