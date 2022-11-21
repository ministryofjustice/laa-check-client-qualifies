module CfeParamBuilders
  class IrregularIncome
    def self.call(form)
      [].tap do |payments|
        payments << create_student_loan(form) if form.student_finance_value&.positive?
        payments << create_other_income(form) if form.other_value&.positive?
      end
    end

    def self.create_student_loan(form)
      {
        "income_type": "student_loan",
        "frequency": "annual",
        "amount": form.student_finance_value,
      }
    end

    def self.create_other_income(form)
      {
        "income_type": "unspecified_source",
        "frequency": "quarterly",
        "amount": form.other_value,
      }
    end
  end
end
