module Cfe
  class VehiclePayloadService < BaseService
    def call
      if relevant_form?(:vehicles_details)
        payload[:vehicles] = multiple_vehicle_details
      elsif relevant_form?(:vehicle_details)
        payload[:vehicles] = single_vehicle_details
      end
    end

    def multiple_vehicle_details
      model = VehiclesDetailsForm.from_session(@session_data)
      CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
    end

    def single_vehicle_details
      details_model = ClientVehicleDetailsForm.from_session(@session_data)
      CfeParamBuilders::Vehicles.call([details_model], smod_applicable: check.smod_applicable?)
    end
  end
end
