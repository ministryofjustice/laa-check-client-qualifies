module Flow
  module Vehicle
    class FinanceHandler
      class << self
        def show_form(session_data)
          VehicleFinanceForm.new(session_data.slice(*VehicleFinanceForm::VEHICLE_FINANCE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params, _session_data)
          VehicleFinanceForm.new(params.require(:vehicle_finance_form).permit(*VehicleFinanceForm::VEHICLE_FINANCE_ATTRIBUTES))
        end

        def model(session_data)
          VehicleModel.load_from_session session_data
        end

        def save_data(cfe_connection, estimate_id, form, session_data)
          age_form = Vehicle::AgeHandler.show_form(session_data)
          date_of_purchase = age_form.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date
          value_form = Vehicle::ValueHandler.show_form(session_data)
          cfe_connection.create_vehicle estimate_id,
                                        date_of_purchase:,
                                        value: value_form.vehicle_value,
                                        loan_amount_outstanding: form.vehicle_pcp ? form.vehicle_finance.presence : 0,
                                        in_regular_use: value_form.vehicle_in_regular_use
        end
      end
    end
  end
end
