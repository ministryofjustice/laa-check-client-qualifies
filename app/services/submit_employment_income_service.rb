class SubmitEmploymentIncomeService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    applicant_form = ApplicantForm.from_session(session_data)
    return unless applicant_form.employed && !applicant_form.passporting

    form = EmploymentForm.from_session(session_data)
    employment_data = CfeParamBuilders::Employments.call(form)

    cfe_connection.create_employment(cfe_assessment_id, employment_data)
  end
end
