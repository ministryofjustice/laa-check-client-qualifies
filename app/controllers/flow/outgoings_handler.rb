module Flow
  class OutgoingsHandler
    OUTGOINGS_ATTRIBUTES = (OutgoingsForm::OUTGOING_ATTRIBUTES + [:outgoings]).freeze

    class << self
      def model(session_data, _index = 0)
        OutgoingsForm.new session_data.slice(*OUTGOINGS_ATTRIBUTES)
      end

      def form(params, _session_data, _index)
        OutgoingsForm.new(params.require(:outgoings_form).permit(*OutgoingsForm::OUTGOING_ATTRIBUTES, outgoings: []))
      end

      def save_data(cfe_connection, estimate_id, outgoings_form, session_data)
        income_form = MonthlyIncomeHandler.model(session_data)

        if income_form.monthly_incomes.include?("student_finance")
          cfe_connection.create_student_loan estimate_id, income_form.student_finance
        end

        cfe_connection.create_regular_payments(estimate_id, income_form, outgoings_form)
      end
    end
  end
end
