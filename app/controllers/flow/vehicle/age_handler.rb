module Flow
  module Vehicle
    class AgeHandler
      class << self
        def model(session_data)
          VehicleAgeForm.new(session_data.slice(*VehicleAgeForm::VEHICLE_AGE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params)
          VehicleAgeForm.new(params.require(:vehicle_age_form).permit(*VehicleAgeForm::VEHICLE_AGE_ATTRIBUTES))
        end
      end
    end
  end
end
