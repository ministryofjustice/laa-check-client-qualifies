module Cfe
  class IrregularIncomePayloadService < BaseService
    def call
      return unless relevant_form?(:other_income)

      form = OtherIncomeForm.from_session(@session_data)

      payments = CfeParamBuilders::IrregularIncome.call(form)
      payload[:irregular_incomes] = { payments: }
    end
  end
end
