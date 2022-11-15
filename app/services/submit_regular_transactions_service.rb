class SubmitRegularTransactionsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    outgoings_form = OutgoingsForm.from_session(cfe_session_data)
    income_form = OtherIncomeForm.from_session(cfe_session_data)

    regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
    cfe_connection.create_regular_payments(cfe_estimate_id, regular_transactions) if regular_transactions.any?
  end
end
