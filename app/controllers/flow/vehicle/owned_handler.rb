module Flow
  module Vehicle
    class OwnedHandler
      class << self
        def show_form(session_data)
          VehicleForm.new session_data.slice(*VehicleForm::VEHICLE_ATTRIBUTES.map(&:to_s))
        end

        def form(params, _session_data)
          VehicleForm.new params.require(:vehicle_form).permit(*VehicleForm::VEHICLE_ATTRIBUTES)
        end

        def model(session_data)
          VehicleModel.load_from_session session_data
        end

        # called when 'no vehicle' selected - nothing to do
        def save_data(cfe_connection, estimate_id, estimate, _session_data); end
      end
    end
  end
end
