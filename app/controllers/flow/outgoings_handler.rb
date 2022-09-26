module Flow
  class OutgoingsHandler
    OUTGOINGS_ATTRIBUTES = (OutgoingsForm::OUTGOING_ATTRIBUTES + [:outgoings]).freeze

    class << self
      def model(session_data)
        OutgoingsForm.new session_data.slice(*OUTGOINGS_ATTRIBUTES)
      end

      def form(params)
        OutgoingsForm.new(params.require(:outgoings_form).permit(*OutgoingsForm::OUTGOING_ATTRIBUTES, outgoings: []))
      end

      def save_data(cfe_connection, estimate_id, outgoings_form, session_data)
        income_form = IncomeHandler.model(session_data)
        cfe_connection.create_student_loan estimate_id, income_form.student_finance
        cfe_connection.create_regular_payments(estimate_id, income_form, outgoings_form)
      end
    end
  end
end
