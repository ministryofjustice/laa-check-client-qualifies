module Flow
  module Vehicle
    class DetailsHandler
      class << self
        def model(session_data)
          VehicleDetailsForm.new(session_data.slice(*VehicleDetailsForm::VEHICLE_DETAILS_ATTRIBUTES.map(&:to_s)))
        end

        def form(params, _session_data)
          VehicleDetailsForm.new(params.require(:vehicle_details_form).permit(*VehicleDetailsForm::VEHICLE_DETAILS_ATTRIBUTES))
        end
      end
    end
  end
end
