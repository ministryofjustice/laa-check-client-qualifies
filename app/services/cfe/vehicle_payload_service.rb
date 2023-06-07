module Cfe
  class VehiclePayloadService < BaseService
    def call
      return unless relevant_form?(:vehicles_details)

      model = VehiclesDetailsForm.from_session(@session_data)
      payload[:vehicles] = CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
    end
  end
end
