class SubmitEmploymentIncomeService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = EmploymentForm.from_session(cfe_session_data)
    return if form.gross_income.blank?

    employment_data = CfeParamBuilders::Employments.call(form)

    cfe_connection.create_employment(cfe_estimate_id, employment_data)
  end
end
