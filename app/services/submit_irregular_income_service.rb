class SubmitIrregularIncomeService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::MonthlyIncomeHandler.model(cfe_session_data)

    if form.monthly_incomes.include?("student_finance")
      create_student_loan cfe_connection, cfe_estimate_id, form.student_finance
    end
  end

  def create_student_loan(cfe_connection, assessment_id, amount)
    if amount.present?
      payments = [
        {
          "income_type": "student_loan",
          "frequency": "annual",
          "amount": amount,
        },
      ]
      cfe_connection.create_student_loan(assessment_id, payments:)
    end
  end
end
