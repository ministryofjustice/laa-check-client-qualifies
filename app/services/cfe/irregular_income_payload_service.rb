module Cfe
  class IrregularIncomePayloadService
    class << self
      def call(session_data, payload)
        check = Check.new session_data
        return if check.skip_income_questions?

        form = BaseService.instantiate_form(session_data, OtherIncomeForm)

        payments = CfeParamBuilders::IrregularIncome.call(form)
        payload[:irregular_incomes] = { payments: }
      end
    end
  end
end
