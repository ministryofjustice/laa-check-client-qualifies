module Flow
  module Vehicle
    class OwnedHandler
      class << self
        def model(session_data, _index)
          VehicleForm.new session_data.slice(*VehicleForm::VEHICLE_ATTRIBUTES.map(&:to_s))
        end

        def form(params, _session_data, _index = 0)
          VehicleForm.new params.require(:vehicle_form).permit(*VehicleForm::VEHICLE_ATTRIBUTES)
        end

        # called when 'no vehicle' selected - nothing to do
        def save_data(cfe_connection, estimate_id, estimate, _session_data); end
      end
    end
  end
end
