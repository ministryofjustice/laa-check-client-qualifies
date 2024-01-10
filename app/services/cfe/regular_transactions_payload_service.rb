module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return unless relevant_form?(:outgoings, OutgoingsForm) ||
        relevant_form?(:other_income, OtherIncomeForm) ||
        relevant_form?(:mortgage_or_loan_payment, MortgageOrLoanPaymentForm) ||
        relevant_form?(:housing_costs, HousingCostsForm) ||
        relevant_form?(:benefit_details, BenefitDetailsForm)

      outgoings_form = instantiate_form(OutgoingsForm) if !early_gross_income_check? && relevant_form?(:outgoings, OutgoingsForm)
      income_form = instantiate_form(OtherIncomeForm)
      benefit_details_form = instantiate_form(BenefitDetailsForm) if relevant_form?(:benefit_details)
      housing_form = if early_gross_income_check?
                       nil
                     elsif relevant_form?(:mortgage_or_loan_payment, MortgageOrLoanPaymentForm)
                       instantiate_form(MortgageOrLoanPaymentForm)
                     elsif relevant_form?(:housing_costs, HousingCostsForm)
                       instantiate_form(HousingCostsForm)
                     end

      regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefit_details_form, housing_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
