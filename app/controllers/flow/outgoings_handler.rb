module Flow
  class OutgoingsHandler
    OUTGOINGS_ATTRIBUTES = (OutgoingsForm::OUTGOING_ATTRIBUTES + [:outgoings]).freeze

    class << self
      def model(session_data)
        OutgoingsForm.new session_data.slice(*OUTGOINGS_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        OutgoingsForm.new(params.require(:outgoings_form).permit(*OutgoingsForm::OUTGOING_ATTRIBUTES, outgoings: []))
      end
    end
  end
end
