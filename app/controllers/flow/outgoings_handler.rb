module Flow
  class OutgoingsHandler
    OUTGOINGS_ATTRIBUTES = (OutgoingsForm::OUTGOING_ATTRIBUTES + [:outgoings]).freeze

    class << self
      def show_form(session_data)
        OutgoingsForm.new session_data.slice(*OUTGOINGS_ATTRIBUTES)
      end

      def form(params, _session_data)
        OutgoingsForm.new(params.require(:outgoings_form).permit(*OutgoingsForm::OUTGOING_ATTRIBUTES, outgoings: []))
      end

      def model(_session_data)
        ValidModel.new(valid?: true)
      end

      def save_data(cfe_connection, estimate_id, outgoings_form, session_data)
        income_form = MonthlyIncomeHandler.show_form(session_data)
        cfe_connection.create_regular_payments(estimate_id, income_form, outgoings_form)
      end
    end
  end
end
