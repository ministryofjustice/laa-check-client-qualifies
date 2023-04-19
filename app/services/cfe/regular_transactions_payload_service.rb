module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return unless relevant_form?(:outgoings) && relevant_form?(:other_income)

      outgoings_form = OutgoingsForm.from_session(@session_data)
      income_form = OtherIncomeForm.from_session(@session_data)

      regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
