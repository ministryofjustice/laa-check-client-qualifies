module Cfe
  class VehiclePayloadService
    class << self
      def call(session_data, payload)
        # return unless BaseService.completed_form?(relevant_steps, :vehicles_details)
        check = Check.new session_data
        return unless check.owns_vehicle?

        model = BaseService.instantiate_form(session_data, VehiclesDetailsForm)
        payload[:vehicles] = CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
      end
    end
  end
end
