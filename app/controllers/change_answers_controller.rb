class ChangeAnswersController < QuestionFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      # here we kick off a call to CFE service to update elibility for gross income, gross partner and disposable (if applicable)
      # kick off a call if those relevant forms are valid? if they aren't then quietly fail
      # detect if the eligibility has changed i.e. become eligible across above three areas, if so we will need a banner for the next screen
      # should we use temporary copy of answers against the saved session data to do this? (pending field)
      if Steps::Helper.last_step_in_group?(session_data, step)
        next_step = next_check_answer_step(step)
        if FeatureFlags.enabled?(:early_eligibility, session_data) && !next_step
          session_data["early_result"] = CfeService.call(session_data)
        end
        if next_step
          redirect_to helpers.check_step_path_from_step(next_step, assessment_code)
        else
          # Promote the temporary copy of the answers to overwrite the original answers
          session[assessment_id] = session_data
          redirect_to check_answers_path(assessment_code:, anchor:)
        end
      else
        redirect_to helpers.check_step_path_from_step(Steps::Helper.next_step_for(session_data, step), assessment_code)
      end
    else
      track_validation_error
      render "question_flow/#{step}"
    end
  end

private

  # While we're in a 'change answers loop', we want to be working with a temporary copy of the answers
  # stored in a section of the session called 'pending'.
  def session_data
    data = super

    # Set up a fresh copy of the answers into the pending section if it's blank or we're
    # starting a new loop
    if !data[:pending] || params[:begin_editing]
      pending = data.dup
      pending[:pending] = nil
      session[assessment_id][:pending] = pending
      pending
    else
      data[:pending]
    end
  end

  def set_back_behaviour
    @back_buttons_invoke_browser_back_behaviour = true
  end

  def anchor
    "table-#{step}"
  end

  def page_name
    "check_#{step}"
  end

  def already_ineligible?
    return unless FeatureFlags.enabled?(:early_eligibility, session_data)

    Steps::Logic.ineligible_gross_income?(session_data)
  end
end
