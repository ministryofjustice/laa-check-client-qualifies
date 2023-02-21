class SubmitRegularTransactionsService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    outgoings_form = OutgoingsForm.from_session(session_data)
    income_form = OtherIncomeForm.from_session(session_data)

    regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
    cfe_connection.create_regular_payments(cfe_assessment_id, regular_transactions) if regular_transactions.any?
  end
end
