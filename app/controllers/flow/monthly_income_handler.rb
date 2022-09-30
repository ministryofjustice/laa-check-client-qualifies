module Flow
  class MonthlyIncomeHandler
    MONTHLY_INCOME_ATTRIBUTES = (MonthlyIncomeForm::INCOME_ATTRIBUTES + [:monthly_incomes]).freeze

    class << self
      def show_form(session_data)
        MonthlyIncomeForm.new session_data.slice(*MONTHLY_INCOME_ATTRIBUTES.map(&:to_s))
      end

      def model(_session_data)
        ValidModel.new(valid?: true)
      end

      def form(params, _session_data)
        MonthlyIncomeForm.new(params.require(:monthly_income_form)
          .permit(*MonthlyIncomeForm::INCOME_ATTRIBUTES, monthly_incomes: []))
      end

      def save_data(cfe_connection, estimate_id, income_form, _session_data)
        # TODO: CFE will raise an error the second time `create_student_loan` is called
        # for a given estimate_id, meaning that submitting the monthly income page
        # twice by using the back button can raise an error
        if income_form.monthly_incomes.include?("student_finance")
          cfe_connection.create_student_loan estimate_id, income_form.student_finance
        end

        # We don't submit any of the other income here, because it gets
        # included with the payload after user submits their monthly outgoings
      end
    end
  end
end
