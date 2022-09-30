module Flow
  class PropertyHandler
    PROPERTY_ATTRIBUTES = [:property_owned].freeze

    class << self
      def model(session_data)
        PropertyForm.new session_data.slice(*PROPERTY_ATTRIBUTES)
      end

      def form(params)
        PropertyForm.new(params.require(:property_form).permit(:property_owned))
      end

      # Will be called when no property owned
      def save_data(cfe_connection, estimate_id, estimate, _session_data); end
    end
  end
end
