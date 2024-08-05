module Cfe
  class RegularTransactionsPayloadService
    class << self
      def call(session_data, payload, relevant_steps)
        return unless BaseService.completed_form?(relevant_steps, :outgoings) ||
          BaseService.completed_form?(relevant_steps, :other_income) ||
          BaseService.completed_form?(relevant_steps, :mortgage_or_loan_payment) ||
          BaseService.completed_form?(relevant_steps, :housing_costs) ||
          BaseService.completed_form?(relevant_steps, :benefit_details)

        outgoings_form = BaseService.instantiate_form(session_data, OutgoingsForm) if BaseService.completed_form?(relevant_steps, :outgoings)
        income_form = BaseService.instantiate_form(session_data, OtherIncomeForm) if BaseService.completed_form?(relevant_steps, :other_income)
        benefit_details_form = BaseService.instantiate_form(session_data, BenefitDetailsForm) if BaseService.completed_form?(relevant_steps, :benefit_details)
        housing_form = if BaseService.completed_form?(relevant_steps, :mortgage_or_loan_payment)
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
