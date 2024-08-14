module Cfe
  class RegularTransactionsPayloadService
    class << self
      def call(session_data, payload, relevant_steps)
        # return unless BaseService.completed_form?(relevant_steps, :outgoings) ||
        #   BaseService.completed_form?(relevant_steps, :other_income) ||
        #   BaseService.completed_form?(relevant_steps, :mortgage_or_loan_payment) ||
        #   BaseService.completed_form?(relevant_steps, :housing_costs) ||
        #   BaseService.completed_form?(relevant_steps, :benefit_details)
        check = Check.new(session_data)
        return if check.skip_income_questions?

        outgoings_form = BaseService.instantiate_form(session_data, OutgoingsForm) if BaseService.completed_form?(relevant_steps, :outgoings)
        # outgoings_form = BaseService.instantiate_form(session_data, OutgoingsForm)
        # income_form = BaseService.instantiate_form(session_data, OtherIncomeForm) if BaseService.completed_form?(relevant_steps, :other_income)
        income_form = BaseService.instantiate_form(session_data, OtherIncomeForm)
        # benefit_details_form = BaseService.instantiate_form(session_data, BenefitDetailsForm) if BaseService.completed_form?(relevant_steps, :benefit_details)
        benefit_details_form = BaseService.instantiate_form(session_data, BenefitDetailsForm) if check.any_benefits?
        housing_form = if check.owns_property_with_mortgage_or_loan?
                         BaseService.instantiate_form(session_data, MortgageOrLoanPaymentForm)
                       elsif BaseService.completed_form?(relevant_steps, :housing_costs)
                         BaseService.instantiate_form(session_data, HousingCostsForm)
                       end

        regular_transactions = CfeParamBuilders::RegularTransactions.call(income_form, outgoings_form, benefit_details_form, housing_form)
        payload[:regular_transactions] = regular_transactions
      end
    end
  end
end
