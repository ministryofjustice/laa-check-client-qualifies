class BuildEstimatesController < EstimateFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      session_data.merge!(@form.session_attributes)
      estimate = load_estimate

      next_step = StepsHelper.next_step_for(estimate, step)
      if next_step
        redirect_to wizard_path next_step
      else
        redirect_to_finish_wizard
      end
    else
      @estimate = load_estimate
      track_validation_error
      render_wizard
    end
  end

  def finish_wizard_path
    check_answers_estimate_path assessment_code
  end
end
