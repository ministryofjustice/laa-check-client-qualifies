class SubmitEmploymentIncomeService < BaseCfeService
  def call(cfe_assessment_id)
    return unless relevant_form?(:employment)

    form = EmploymentForm.from_session(@session_data)
    employment_data = CfeParamBuilders::Employments.call(form)

    cfe_connection.create_employment(cfe_assessment_id, employment_data)
  end
end
