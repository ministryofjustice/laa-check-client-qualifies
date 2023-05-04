module Cfe
  class VehiclePayloadService < BaseService
    def call
      return unless relevant_form?(:vehicle_details)

      details_model = ClientVehicleDetailsForm.from_session(@session_data)
      vehicles = CfeParamBuilders::Vehicles.call(details_model,
                                                 in_dispute: details_model.vehicle_in_dispute && check.smod_applicable?)
      payload[:vehicles] = vehicles
    end
  end
end
