class SubmitVehicleService < BaseCfeService
  def call(cfe_assessment_id)
    return unless relevant_form?(:vehicle_details)

    details_model = VehicleDetailsForm.from_session(@session_data)
    vehicles = CfeParamBuilders::Vehicles.call(details_model)
    cfe_connection.create_vehicles cfe_assessment_id, vehicles:
  end
end
