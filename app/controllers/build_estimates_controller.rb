class BuildEstimatesController < EstimateFlowController
  before_action :load_estimate_id

  def update
    handler = HANDLER_CLASSES.fetch(step)
    @form = handler.form(params, session_data)

    if @form.valid?
      session_data.merge!(@form.attributes)
      estimate = load_estimate
      handler.save_data(cfe_connection, estimate_id, @form, session_data) if StepsHelper.last_step_in_group?(estimate, step)

      redirect_to wizard_path StepsHelper.next_step_for(estimate, step)
    else
      @estimate = load_estimate
      render_wizard
    end
  end

private

  def load_estimate_id
    @estimate_id = params[:estimate_id]
  end
end
