module Cfe
  class VehiclePayloadService < BaseService
    def call
      return if early_gross_income_check? || !relevant_form?(:vehicles_details, VehiclesDetailsForm)

      model = instantiate_form(VehiclesDetailsForm)
      payload[:vehicles] = CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
    end
  end
end
