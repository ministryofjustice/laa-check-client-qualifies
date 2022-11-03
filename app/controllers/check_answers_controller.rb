class CheckAnswersController < EstimateFlowController
  before_action :set_back_behaviour
  include CheckAnswersFinished

  def update
    handler = HANDLER_CLASSES.fetch(step)
    @form = handler.form(params, session_data)

    if @form.valid?
      session_data.merge!(@form.attributes)
      estimate = load_estimate
      if StepsHelper.last_step_in_group?(estimate, step)
        next_step = next_check_answer_step(HANDLER_CLASSES, step, estimate, session_data)
        if next_step
          redirect_to wizard_path next_step
        else
          redirect_to check_answers_estimate_path(estimate_id, anchor:)
        end
      else
        redirect_to wizard_path StepsHelper.next_step_for(estimate, step)
      end
    else
      @estimate = load_estimate
      render "estimate_flow/#{step}"
    end
  end

  private

  def set_back_behaviour
    @back_buttons_invoke_browser_back_behaviour = true
  end

  def anchor
    "#{relevant_check_answers_section_label}-section"
  end

  def relevant_check_answers_section_label
    CheckAnswers::RelevantSectionFinderService.call(step, session_data)
  end
end
