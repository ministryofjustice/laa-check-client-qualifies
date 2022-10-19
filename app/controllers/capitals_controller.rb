class CapitalsController < EstimateFlowController
  steps :property_info, :vehicle_info, :assets

  HANDLER_CLASSES = {
    assets: Flow::AssetHandler
  }

  def show
    case step
    when :property_info
      redirect_to estimate_build_estimate_capital_properties_path estimate_id, params[:build_estimate_id], :vehicle_info
    when :vehicle_info
      redirect_to estimate_build_estimate_capital_vehicles_path estimate_id, params[:build_estimate_id], :assets
    else
      super
    end
  end

  # def update
  #   handler = HANDLER_CLASSES.fetch(step)
  #   @form = handler.form(params, session_data)
  #
  #   if @form.valid?
  #     session_data.merge!(@form.attributes)
  #     handler.save_data(cfe_connection, estimate_id, @form, session_data)
  #
  #     redirect_to next_wizard_path
  #   else
  #     @estimate = load_estimate
  #     render_wizard
  #   end
  # end

  def finish_wizard_path
    estimate_build_estimate_path estimate_id, params[:build_estimate_id]
  end

  protected

  def handler_classes
    HANDLER_CLASSES
  end
end
