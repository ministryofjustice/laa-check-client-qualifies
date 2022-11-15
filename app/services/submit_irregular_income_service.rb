class SubmitIrregularIncomeService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = OtherIncomeForm.from_session(cfe_session_data)

    payments = CfeParamBuilders::IrregularIncome.call(form)
    cfe_connection.create_irregular_income(cfe_estimate_id, payments) if payments.any?
  end
end
