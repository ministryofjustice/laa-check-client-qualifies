module Flow
  class VehicleHandler
    VEHICLE_ATTRIBUTES = [:vehicle_owned].freeze

    class << self
      def model(session_data)
        VehicleForm.new session_data.slice(*VEHICLE_ATTRIBUTES)
      end

      def form(params)
        VehicleForm.new(params.require(:vehicle_form).permit(:vehicle_owned))
      end

      def save_data(cfe_connection, estimate_id, estimate, _other); end
    end
  end
end
