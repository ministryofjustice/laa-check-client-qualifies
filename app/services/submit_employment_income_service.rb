class SubmitEmploymentIncomeService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    applicant_form = ApplicantForm.from_session(cfe_session_data)
    return unless applicant_form.employed

    form = EmploymentForm.from_session(cfe_session_data)
    employment_data = CfeParamBuilders::Employments.call(form)

    cfe_connection.create_employment(cfe_estimate_id, employment_data)
  end
end
