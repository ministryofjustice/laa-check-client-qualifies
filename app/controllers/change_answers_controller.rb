class ChangeAnswersController < QuestionFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      if Steps::Helper.last_step_in_group?(session_data, step)
        if tag_from(step) == (:gross_income || :disposable_income)
          session_data["api_result"] = CfeService.call(session_data, early_eligibility: tag_from(step))
        end

        next_step = next_check_answer_step(step)
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
end
