module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return if early_eligibility?
      return unless relevant_form?(:outgoings) ||
        relevant_form?(:other_income) ||
        relevant_form?(:mortgage_or_loan_payment) ||
        relevant_form?(:housing_costs) ||
        relevant_form?(:benefit_details)

      outgoings_form = instantiate_form(OutgoingsForm) unless early_eligibility?
      income_form = instantiate_form(OtherIncomeForm)
      benefit_details_form = instantiate_form(BenefitDetailsForm) if relevant_form?(:benefit_details)
      housing_form = if early_eligibility?
                       nil
                     elsif relevant_form?(:mortgage_or_loan_payment)
                       instantiate_form(MortgageOrLoanPaymentForm)
                     elsif relevant_form?(:housing_costs)
                       instantiate_form(HousingCostsForm)
                     end

      regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefit_details_form, housing_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
