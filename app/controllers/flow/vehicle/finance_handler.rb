module Flow
  module Vehicle
    class FinanceHandler
      class << self
        def model(session_data)
          VehicleFinanceForm.new(session_data.slice(*VehicleFinanceForm::VEHICLE_FINANCE_ATTRIBUTES.map(&:to_s)))
        end

        def form(params, _session_data)
          VehicleFinanceForm.new(params.require(:vehicle_finance_form).permit(*VehicleFinanceForm::VEHICLE_FINANCE_ATTRIBUTES))
        end
      end
    end
  end
end
