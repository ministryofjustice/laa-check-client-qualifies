module Flow
  module Vehicle
    class AgeHandler
      class << self
        def show_form(session_data)
          VehicleAgeForm.new(session_data.slice(*VehicleAgeForm::VEHICLE_AGE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params, _session_data)
          VehicleAgeForm.new(params.require(:vehicle_age_form).permit(*VehicleAgeForm::VEHICLE_AGE_ATTRIBUTES))
        end

        def model(session_data)
          VehicleModel.load_from_session session_data
        end
      end
    end
  end
end
