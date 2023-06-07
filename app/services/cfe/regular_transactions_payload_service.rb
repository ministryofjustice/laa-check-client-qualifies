module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return unless relevant_form?(:outgoings) || relevant_form?(:other_income) || relevant_form?(:mortgage_or_loan_payment) || relevant_form?(:housing_costs)

      outgoings_form = OutgoingsForm.from_session(@session_data)
      income_form = OtherIncomeForm.from_session(@session_data)
      housing_form = if relevant_form?(:mortgage_or_loan_payment)
                       MortgageOrLoanPaymentForm.from_session(@session_data)
                     elsif relevant_form?(:housing_costs)
                       HousingCostsForm.from_session(@session_data)
                     end

      regular_transactions = CfeParamBuilders::HouseholdFlowRegularTransactions.call(income_form, outgoings_form, housing_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
