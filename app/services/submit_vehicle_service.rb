class SubmitVehicleService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    owned_model = VehicleForm.from_session(cfe_session_data)
    return unless owned_model.vehicle_owned

    details_model = ClientVehicleDetailsForm.from_session(cfe_session_data)
    vehicles = CfeParamBuilders::Vehicles.call(details_model, in_dispute: details_model.vehicle_in_dispute)
    cfe_connection.create_vehicle cfe_estimate_id, vehicles:
  end
end
