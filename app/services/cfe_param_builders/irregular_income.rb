module CfeParamBuilders
  class IrregularIncome
    def self.call(form)
      payments = []
      payments << create_student_loan(form)
      payments << create_other_income(form)
      payments.compact
    end

    def self.create_student_loan(form)
      amount = extract_amount(form, :student_finance)

      return unless amount.positive?

      {
        "income_type": "student_loan",
        "frequency": "annual",
        "amount": amount,
      }
    end

    def self.create_other_income(form)
      amount = extract_amount(form, :other)

      return unless amount.positive?

      {
        "income_type": "unspecified_source",
        "frequency": form.level_of_help == "controlled" ? "monthly" : "quarterly",
        "amount": amount,
      }
    end

    def self.extract_amount(form, attribute)
      if FeatureFlags.enabled?(:conditional_reveals, form.check.session_data)
        form.send(:"#{attribute}_received") ? form.send(:"#{attribute}_conditional_value") : 0
      else
        form.send(:"#{attribute}_value")
      end
    end
  end
end
