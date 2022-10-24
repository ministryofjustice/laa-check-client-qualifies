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
    # line below is missing branch coverage. However I am not sure it is required. we validate on the page
    # that a value is entered if student_loan is selected, if no value is entered the estimate cannot progress and therefore no submission
    # to CFE is possible.
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
