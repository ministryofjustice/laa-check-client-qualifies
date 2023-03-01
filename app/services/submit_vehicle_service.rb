class SubmitVehicleService < BaseCfeService
  def call(cfe_assessment_id)
    return unless relevant_form?(:vehicle_details)

    details_model = ClientVehicleDetailsForm.from_session(@session_data)
    vehicles = CfeParamBuilders::Vehicles.call(details_model)
    cfe_connection.create_vehicle cfe_assessment_id, vehicles:
  end
end
