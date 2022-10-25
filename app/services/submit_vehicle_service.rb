class SubmitVehicleService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    owned_model = Flow::Vehicle::OwnedHandler.model(cfe_session_data)
    return unless owned_model.vehicle_owned

    details_model = Flow::Vehicle::DetailsHandler.model(cfe_session_data)

    submit_vehicle_finance_data(cfe_estimate_id, details_model)
  end

  def submit_vehicle_finance_data(cfe_estimate_id, model)
    date_of_purchase = model.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date
    cfe_connection.create_vehicle cfe_estimate_id,
                                  date_of_purchase:,
                                  value: model.vehicle_value,
                                  loan_amount_outstanding: model.vehicle_finance.presence || 0,
                                  in_regular_use: model.vehicle_in_regular_use
  end
end
