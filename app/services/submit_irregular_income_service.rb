class SubmitIrregularIncomeService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::Handler.model_from_session(:other_income, cfe_session_data)
    payments = []

    payments << create_student_loan(form) if form.student_finance_value&.positive?
    payments << create_other_income(form) if form.other_value&.positive?

    cfe_connection.create_irregular_income(cfe_estimate_id, payments) if payments.any?
  end

  def create_student_loan(form)
    {
      "income_type": "student_loan",
      "frequency": "annual",
      "amount": form.student_finance_value,
    }
  end

  def create_other_income(form)
    {
      "income_type": "unspecified_source",
      "frequency": "quarterly",
      "amount": form.other_value,
    }
  end
end
