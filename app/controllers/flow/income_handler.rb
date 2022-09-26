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
    end
  end
end
