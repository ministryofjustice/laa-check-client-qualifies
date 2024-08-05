module Cfe
  class VehiclePayloadService
    class << self
      def call(session_data, payload, relevant_steps)
        return unless BaseService.completed_form?(relevant_steps, :vehicles_details)

        model = BaseService.instantiate_form(session_data, VehiclesDetailsForm)
        check = Check.new session_data
        payload[:vehicles] = CfeParamBuilders::Vehicles.call(model.items, smod_applicable: check.smod_applicable?)
      end
    end
  end
end
