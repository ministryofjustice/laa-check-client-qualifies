class BuildEstimatesController < EstimateFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      next_step = Steps::Helper.next_step_for(session_data, step)
      if next_step
        redirect_to wizard_path next_step
      else
        redirect_to_finish_wizard
      end
    else
      track_validation_error
      render_wizard
    end
  end

  def finish_wizard_path
    check_answers_estimate_path assessment_code
  end
end
