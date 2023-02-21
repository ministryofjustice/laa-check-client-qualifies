class SubmitVehicleService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    owned_model = VehicleForm.from_session(session_data)
    return unless owned_model.vehicle_owned

    details_model = ClientVehicleDetailsForm.from_session(session_data)
    vehicles = CfeParamBuilders::Vehicles.call(details_model, in_dispute: details_model.vehicle_in_dispute)
    cfe_connection.create_vehicle cfe_assessment_id, vehicles:
  end
end
