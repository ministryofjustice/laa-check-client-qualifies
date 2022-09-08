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

      def save_data(cfe_connection, estimate_id, income_form, outgoings_form)
        IncomeHandler.save_data(cfe_connection, estimate_id, income_form, outgoings_form)
      end
    end
  end
end
