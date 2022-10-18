module Flow
  module Vehicle
    class AgeHandler
      class << self
        def model(session_data, _index = 0)
          VehicleAgeForm.new(session_data.slice(*VehicleAgeForm::VEHICLE_AGE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params, _session_data, _index)
          VehicleAgeForm.new(params.require(:vehicle_age_form).permit(*VehicleAgeForm::VEHICLE_AGE_ATTRIBUTES))
        end
      end
    end
  end
end
