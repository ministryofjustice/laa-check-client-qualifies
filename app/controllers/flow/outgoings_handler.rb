module Flow
  class OutgoingsHandler
    class << self
      def model(session_data)
        OutgoingsForm.new session_data.slice(*OutgoingsForm::OUTGOINGS_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        OutgoingsForm.new(params.require(:outgoings_form).permit(*OutgoingsForm::OUTGOINGS_ATTRIBUTES))
      end
    end
  end
end
