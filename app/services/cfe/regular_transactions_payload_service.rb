module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return unless completed_form?(:outgoings) ||
        completed_form?(:other_income) ||
        completed_form?(:mortgage_or_loan_payment) ||
        completed_form?(:housing_costs) ||
        completed_form?(:benefit_details)

      outgoings_form = instantiate_form(OutgoingsForm) if completed_form? :outgoings
      income_form = instantiate_form(OtherIncomeForm) if completed_form? :other_income
      benefit_details_form = instantiate_form(BenefitDetailsForm) if completed_form?(:benefit_details)
      housing_form = if completed_form?(:mortgage_or_loan_payment)
                       instantiate_form(MortgageOrLoanPaymentForm)
                     elsif completed_form?(:housing_costs)
                       instantiate_form(HousingCostsForm)
                     end

      regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefit_details_form, housing_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
