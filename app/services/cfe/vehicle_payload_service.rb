module Cfe
  class VehiclePayloadService < BaseService
    def call
      return unless completed_form?(:vehicles_details)

      model = instantiate_form(VehiclesDetailsForm)
      payload[:vehicles] = CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
    end
  end
end
