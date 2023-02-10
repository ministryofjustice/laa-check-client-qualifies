class CheckAnswersController < EstimateFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      session_data.merge!(@form.session_attributes)
      estimate = load_estimate
      if StepsHelper.last_step_in_group?(estimate, step)
        next_step = next_check_answer_step(step, estimate)
        if next_step
          redirect_to wizard_path next_step
        else
          redirect_to check_answers_estimate_path(estimate_id, anchor:)
        end
      else
        redirect_to wizard_path StepsHelper.next_step_for(estimate, step)
      end
    else
      track_validation_error(assessment_id: estimate_id)
      @estimate = load_estimate
      render "estimate_flow/#{step}"
    end
  end

private

  def set_back_behaviour
    @back_buttons_invoke_browser_back_behaviour = true
  end

  def anchor
    CheckAnswers::SectionIdFinder.call(step)
  end

  def page_name
    "check_#{step}"
  end
end
