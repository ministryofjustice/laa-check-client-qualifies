class SubmitIrregularIncomeService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    form = OtherIncomeForm.from_session(session_data)

    payments = CfeParamBuilders::IrregularIncome.call(form)
    cfe_connection.create_irregular_income(cfe_assessment_id, payments) if payments.any?
  end
end
