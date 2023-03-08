module Cfe
  class SubmitVehicleService < BaseService
    def call(cfe_assessment_id)
      return unless relevant_form?(:vehicle_details)

      details_model = ClientVehicleDetailsForm.from_session(@session_data)
      vehicles = CfeParamBuilders::Vehicles.call(details_model, in_dispute: details_model.vehicle_in_dispute)
      cfe_connection.create_vehicles cfe_assessment_id, vehicles
    end
  end
end
