module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return unless relevant_form?(:outgoings) || relevant_form?(:other_income) || relevant_form?(:mortgage_or_loan_payment) || relevant_form?(:housing_costs)

      outgoings_form = instantiate_form(OutgoingsForm)
      income_form = instantiate_form(OtherIncomeForm)
      housing_form = if relevant_form?(:mortgage_or_loan_payment)
                       instantiate_form(MortgageOrLoanPaymentForm)
                     elsif relevant_form?(:housing_costs)
                       instantiate_form(HousingCostsForm)
                     end

      regular_transactions = CfeParamBuilders::HouseholdFlowRegularTransactions.call(income_form, outgoings_form, housing_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
