module Cfe
  class RegularTransactionsPayloadService < BaseService
    def call
      return if check.skip_income_questions?

      outgoings_form = instantiate_form(OutgoingsForm) if check.has_outgoings?
      income_form = instantiate_form(OtherIncomeForm) if check.has_other_income?
      benefit_details_form = instantiate_form(BenefitDetailsForm) if check.any_benefits?
      housing_form = if check.owns_property_with_mortgage_or_loan?
                       instantiate_form(MortgageOrLoanPaymentForm)
                     elsif check.has_housing_costs?
                       instantiate_form(HousingCostsForm)
                     end

      regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefit_details_form, housing_form)
      payload[:regular_transactions] = regular_transactions
    end
  end
end
