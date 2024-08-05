module Cfe
  class IrregularIncomePayloadService
    class << self
      def call(session_data, payload, completed_steps)
        # sometimes the 'relevant_steps' parameter is completed_steps
        # so this answer isn't quite as simple as it looks. Really these
        # calls should be avoided if the data set isn't cohesive -
        # which I think might be dealt with by EL-1668
        return unless BaseService.completed_form?(completed_steps, :other_income)

        # return if check.skip_income_questions?

        form = BaseService.instantiate_form(session_data, OtherIncomeForm)

        payments = CfeParamBuilders::IrregularIncome.call(form)
        payload[:irregular_incomes] = { payments: }
      end
    end
  end
end
