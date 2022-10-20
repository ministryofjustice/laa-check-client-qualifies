class VehiclesController < EstimateFlowController
  HANDLER_CLASSES = {
    vehicle: Flow::Vehicle::OwnedHandler,
    vehicle_value: Flow::Vehicle::ValueHandler,
    vehicle_age: Flow::Vehicle::AgeHandler,
    vehicle_finance: Flow::Vehicle::FinanceHandler,
  }.freeze

  steps :vehicle, :vehicle_value, :vehicle_age, :vehicle_finance

  def update
    handler = handler_classes.fetch(step)
    @form = handler.form(params, session_data)

    if @form.valid?
      session_data.merge!(@form.attributes)
      estimate = load_estimate

      if estimate.vehicle_owned
        if estimate.vehicle_in_regular_use
          last_step = :vehicle_finance
        else
          last_step = :vehicle_value
        end
      else
        last_step = :vehicle
      end

      if step == last_step
        handler.save_data(cfe_connection, estimate_id, @form, session_data)
        redirect_to finish_wizard_path
      else
        redirect_to next_wizard_path
      end
    else
      @estimate = load_estimate
      render_wizard
    end
  end

  def finish_wizard_path
    estimate_build_estimate_capital_path estimate_id, params[:build_estimate_id], params[:capital_id]
  end

  protected

  def handler_classes
    HANDLER_CLASSES
  end

  private

  # def all_steps
  #   self.steps = [:property, :property_entry]
  # end
  #
  # def show_decide_steps
  #   model = load_estimate
  #   if model.owned?
  #     self.steps = [:property, :property_entry]
  #   else
  #     self.steps = [:property]
  #   end
  # end
  #
  # def update_decide_steps
  #   model = params[:id] == "property" ? Flow::PropertyHandler.form(params, session_data) : load_estimate
  #   if model.owned?
  #     self.steps = [:property, :property_entry]
  #   else
  #     self.steps = [:property]
  #   end
  # end
end