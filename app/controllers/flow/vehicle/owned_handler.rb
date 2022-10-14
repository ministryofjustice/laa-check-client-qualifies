module Flow
  module Vehicle
    class OwnedHandler
      class << self
        def model(session_data)
          VehicleForm.new session_data.slice(*VehicleForm::VEHICLE_ATTRIBUTES.map(&:to_s))
        end

        def form(params, _session_data)
          VehicleForm.new params.require(:vehicle_form).permit(*VehicleForm::VEHICLE_ATTRIBUTES)
        end
      end
    end
  end
end
