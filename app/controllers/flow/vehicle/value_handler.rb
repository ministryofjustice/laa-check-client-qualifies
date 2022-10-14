module Flow
  module Vehicle
    class ValueHandler
      class << self
        def model(session_data)
          VehicleValueForm.new(session_data.slice(*VehicleValueForm::VEHICLE_VALUE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params, _session_data)
          VehicleValueForm.new(params.require(:vehicle_value_form).permit(*VehicleValueForm::VEHICLE_VALUE_ATTRIBUTES))
        end
      end
    end
  end
end
