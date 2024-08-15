module Cfe
  class IrregularIncomePayloadService < BaseService
    def call
      return if check.skip_income_questions?

      form = instantiate_form(OtherIncomeForm)

      payments = CfeParamBuilders::IrregularIncome.call(form)
      payload[:irregular_incomes] = { payments: }
    end
  end
end
