module CfeParamBuilders
  class IrregularIncome
    def self.call(form)
      payments = []
      payments << create_student_loan(form)
      payments << create_other_income(form)
      payments.compact
    end

    def self.create_student_loan(form)
      amount = if FeatureFlags.enabled?(:conditional_reveals, form.check.session_data)
                 form.student_finance_received ? form.student_finance_conditional_value : 0
               else
                 form.student_finance_value
               end

      return unless amount.positive?

      {
        "income_type": "student_loan",
        "frequency": "annual",
        "amount": amount,
      }
    end

    def self.create_other_income(form)
      amount = if FeatureFlags.enabled?(:conditional_reveals, form.check.session_data)
                 form.other_received ? form.other_conditional_value : 0
               else
                 form.other_value
               end

      return unless amount.positive?

      {
        "income_type": "unspecified_source",
        "frequency": form.level_of_help == "controlled" ? "monthly" : "quarterly",
        "amount": amount,
      }
    end
  end
end
