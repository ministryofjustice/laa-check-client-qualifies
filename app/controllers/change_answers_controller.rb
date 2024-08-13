class ChangeAnswersController < QuestionFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      # Note that this merge! has the side effect of altering the session data in the '@check' variable
      # that was loaded by our base class which looks quite awkward
      session_data.merge!(@form.attributes_for_export_to_session)
      if @check.consistent?
        if Steps::Helper.last_step_in_group?(session_data, step)
          # if we have a 'check stops' block, it may have been removed even if we're consistent
          # e.g. going from employed to unemployed
          # but only check this if we have financial information in the check
          if Steps::Logic.check_stops_at_gross_income?(session_data) && !Steps::Logic.non_means_tested?(session_data)
            last_step_with_data = Steps::Helper.last_step_with_valid_data(session_data)
            completed_steps = Steps::Helper.completed_steps_for(session_data, last_step_with_data)
            cfe_result = CfeService.result(session_data, completed_steps)

            if cfe_result.ineligible_gross_income?
              # no change - go back to check answers
              save_and_redirect_to_check_answers
            else
              # eligibility changed - remove 'ineligible' block and show notification
              session_data.delete IneligibleGrossIncomeForm::SELECTION
              flash[:notice] = I18n.t("service.change_eligibility")
              redirect_to_next_question
            end
          else
            save_and_redirect_to_check_answers
          end
        else
          next_step = Steps::Helper.next_step_for(session_data, step)
          redirect_to helpers.check_step_path_from_step(next_step, assessment_code)
        end
      else
        redirect_to_next_question
      end
    else
      track_validation_error
      render "question_flow/#{step}"
    end
  end

private

  def save_and_redirect_to_check_answers
    # Promote the temporary copy of the answers to overwrite the original answers
    session[assessment_id] = session_data
    redirect_to check_answers_path(assessment_code:, anchor:)
  end

  def redirect_to_next_question
    next_check_answer_step = Steps::Helper.remaining_steps_for(session_data, step)
                 .drop_while { |thestep|
                   Flow::Handler.model_from_session(thestep, session_data).valid?
                 }.first
    redirect_to helpers.check_step_path_from_step(next_check_answer_step, assessment_code)
  end

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
