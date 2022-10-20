class SubmitVehicleService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    finance_form = Flow::Vehicle::FinanceHandler.model(cfe_session_data)

    finance_form.vehicle_pcp.present? ? submit_vehicle_finance_data(cfe_estimate_id, cfe_session_data) : submit_vehicle_value_data(cfe_estimate_id, cfe_session_data)
  end

  def submit_vehicle_value_data(cfe_estimate_id, cfe_session_data)
    value_form = Flow::Vehicle::ValueHandler.model(cfe_session_data)
    return if value_form.vehicle_value.blank?

    cfe_connection.create_vehicle cfe_estimate_id, date_of_purchase: Time.zone.today.to_date,
                                                   value: value_form.vehicle_value,
                                                   loan_amount_outstanding: 0,
                                                   in_regular_use: value_form.vehicle_in_regular_use
  end

  def submit_vehicle_finance_data(cfe_estimate_id, cfe_session_data)
    finance_form = Flow::Vehicle::FinanceHandler.model(cfe_session_data)
    value_form = Flow::Vehicle::ValueHandler.model(cfe_session_data)
    age_form = Flow::Vehicle::AgeHandler.model(cfe_session_data)
    date_of_purchase = age_form.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date
    cfe_connection.create_vehicle cfe_estimate_id,
                                  date_of_purchase:,
                                  value: value_form.vehicle_value,
                                  loan_amount_outstanding: finance_form.vehicle_finance.presence,
                                  in_regular_use: value_form.vehicle_in_regular_use
  end
end
