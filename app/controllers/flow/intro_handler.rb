module Flow
  class IntroHandler
    class << self
      def model(session_data)
        IntroForm.new session_data.slice(*IntroForm::INTRO_ATTRIBUTES.map(&:to_s))
      end

      def form(params)
        IntroForm.new(params.require(:intro_form).permit(*IntroForm::INTRO_ATTRIBUTES))
      end

      def save_data(cfe_connection, estimate_id, estimate, _other)
        cfe_connection.create_dependants(estimate_id, estimate.dependant_count) if estimate.dependants
      end
    end
  end
end
