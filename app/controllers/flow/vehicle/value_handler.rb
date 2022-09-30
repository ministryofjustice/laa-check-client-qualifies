module Flow
  module Vehicle
    class ValueHandler
      class << self
        def model(session_data)
          VehicleValueForm.new(session_data.slice(*VehicleValueForm::VEHICLE_VALUE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params)
          VehicleValueForm.new(params.require(:vehicle_value_form).permit(*VehicleValueForm::VEHICLE_VALUE_ATTRIBUTES))
        end

        def save_data(cfe_connection, estimate_id, value_form, _session_data)
          cfe_connection.create_vehicle estimate_id, date_of_purchase: Time.zone.today.to_date,
                                                     value: value_form.vehicle_value,
                                                     loan_amount_outstanding: 0,
                                                     in_regular_use: value_form.vehicle_in_regular_use
        end
      end
    end
  end
end
