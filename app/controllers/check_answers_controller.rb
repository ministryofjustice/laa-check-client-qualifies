class CheckAnswersController < EstimateFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.session_attributes)
      if Steps::Helper.last_step_in_group?(session_data, step)
        next_step = next_check_answer_step(step)
        if next_step
          redirect_to wizard_path next_step
        else
          redirect_to check_answers_estimate_path(assessment_code, anchor:)
        end
      else
        redirect_to wizard_path Steps::Helper.next_step_for(session_data, step)
      end
    else
      track_validation_error
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
