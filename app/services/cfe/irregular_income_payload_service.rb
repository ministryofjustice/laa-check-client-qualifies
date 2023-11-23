module Cfe
  class IrregularIncomePayloadService < BaseService
    def call
      return if !relevant_form?(:other_income) || early_employment_income_result? || early_benefits_income_result?

      form = instantiate_form(OtherIncomeForm)

      payments = CfeParamBuilders::IrregularIncome.call(form)
      payload[:irregular_incomes] = { payments: }
    end
  end
end
