module Flow
  class PropertyHandler
    PROPERTY_ATTRIBUTES = [:property_owned].freeze

    class << self
      def model(session_data)
        PropertyForm.new session_data.slice(*PROPERTY_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        PropertyForm.new(params.require(:property_form).permit(:property_owned))
      end
    end
  end
end
