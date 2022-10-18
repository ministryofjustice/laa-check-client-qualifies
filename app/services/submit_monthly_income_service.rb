class SubmitMonthlyIncomeService < CfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::MonthlyIncomeHandler.model(cfe_session_data)

    if form.monthly_incomes.include?("student_finance")
      cfe_connection.create_student_loan cfe_estimate_id, form.student_finance
    end

    cfe_connection.create_regular_payments(cfe_estimate_id, form, nil)
  end
end
