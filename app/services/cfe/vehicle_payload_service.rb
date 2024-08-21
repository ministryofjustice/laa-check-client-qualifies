module Cfe
  class VehiclePayloadService < BaseService
    def call
      return unless check.owns_vehicle?

      model = instantiate_form(VehiclesDetailsForm)
      payload[:vehicles] = CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
    end
  end
end
