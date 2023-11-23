module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return unless relevant_form?(:outgoings) ||
        relevant_form?(:other_income) ||
        relevant_form?(:mortgage_or_loan_payment) ||
        relevant_form?(:housing_costs) ||
        relevant_form?(:benefit_details)

      outgoings_form = instantiate_form(OutgoingsForm) if !early_gross_income_result? && relevant_form?(:outgoings)
      income_form = instantiate_form(OtherIncomeForm) if !early_employment_income_result? && !early_benefits_income_result?
      benefit_details_form = instantiate_form(BenefitDetailsForm) if relevant_form?(:benefit_details) && !early_employment_income_result?
      housing_form = if early_gross_income_result?
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
