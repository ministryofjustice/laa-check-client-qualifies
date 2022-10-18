class CheckAnswersController < EstimateFlowController
  before_action :set_back_behaviour

  def update
    handler = HANDLER_CLASSES.fetch(step)
    @form = handler.form(params, session_data)

    if @form.valid?
      session_data.merge!(@form.attributes)
      estimate = load_estimate
      if StepsHelper.step_should_save?(estimate, step)
        handler.save_data(cfe_connection, estimate_id, @form, session_data)
        redirect_to estimate_build_estimate_path(estimate_id, :check_answers)
      else
        redirect_to wizard_path StepsHelper.next_step_for(estimate, step)
      end
    else
      @estimate = load_estimate
      render "estimate_flow/#{step}"
    end
  end

  def set_back_behaviour
    @back_buttons_invoke_browser_back_behaviour = true
  end
end
