module Flow
  class PropertyHandler
    PROPERTY_ATTRIBUTES = [:property_owned].freeze

    class << self
      def model(session_data)
        PropertyForm.new session_data.slice(*PROPERTY_ATTRIBUTES.map(&:to_s))
      end

      def form(params)
        PropertyForm.new(params.require(:property_form).permit(:property_owned))
      end

      def save_data(cfe_connection, estimate_id, estimate, _session_data); end
    end
  end
end
