module Cfe
  class IrregularIncomePayloadService < BaseService
    def call
      return unless relevant_form?(:other_income) && !other_income_invalid? && !early_employment_income_result? && !early_benefits_income_result? && !early_partner_employment_income_result? && !early_partner_benefits_income_result?

      form = instantiate_form(OtherIncomeForm)

      payments = CfeParamBuilders::IrregularIncome.call(form)
      payload[:irregular_incomes] = { payments: }
    end
  end
end
