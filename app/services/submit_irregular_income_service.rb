class SubmitIrregularIncomeService < BaseCfeService
  def call(cfe_assessment_id)
    return unless relevant_form?(:other_income)

    form = OtherIncomeForm.from_session(@session_data)

    payments = CfeParamBuilders::IrregularIncome.call(form)
    cfe_connection.create_irregular_incomes(cfe_assessment_id, payments) if payments.any?
  end
end
