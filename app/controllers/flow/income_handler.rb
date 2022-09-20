module Flow
  class IncomeHandler
    MONTHLY_INCOME_ATTRIBUTES = (MonthlyIncomeForm::INCOME_ATTRIBUTES + [:monthly_incomes]).freeze

    class << self
      def model(session_data)
        MonthlyIncomeForm.new session_data.slice(*MONTHLY_INCOME_ATTRIBUTES)
      end

      def form(params)
        MonthlyIncomeForm.new(params.require(:monthly_income_form)
          .permit(*MonthlyIncomeForm::INCOME_ATTRIBUTES, monthly_incomes: []))
      end

      def save_data(cfe_connection, estimate_id, income_form, _session_data)
        cfe_connection.create_student_loan estimate_id, income_form.student_finance
        cfe_connection.create_regular_payments(estimate_id, income_form, nil)
      end
    end
  end
end
