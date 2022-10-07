module Flow
  class VehicleHandler
    VEHICLE_ATTRIBUTES = [:vehicle_owned].freeze

    class << self
      def model(session_data)
        VehicleForm.new session_data.slice(*VEHICLE_ATTRIBUTES)
      end

      def form(params, _session_data)
        VehicleForm.new(params.require(:vehicle_form).permit(:vehicle_owned))
      end

      def save_data(cfe_connection, estimate_id, estimate, _session_data); end
    end
  end
end
