class ChangeAnswersController < QuestionFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      # Note that this merge! has the side effect of altering the session data in the '@check' variable
      # that was loaded by our base class which looks quite awkward
      session_data.merge!(@form.attributes_for_export_to_session)
      next_step = step_with_inconsistent_data
      if Steps::Helper.cannot_use_service?(session_data, step)
        redirect_to cannot_use_service_path assessment_code:, step:
      # we need to check for shared_ownership_housing_costs to determine if we need to show property_entry screen when in the change loop
      elsif Steps::Helper.display_property_entry_in_change_answers?(session_data, step)
        redirect_to helpers.check_step_path_from_step(:property_entry, assessment_code)
      # we need to check for aggregated_means so we know when to show the ":how_to_aggregate" screen when in a change loop
      elsif next_step && step != :aggregated_means
        redirect_to helpers.check_step_path_from_step(next_step, assessment_code)
      elsif Steps::Helper.last_step_in_group?(session_data, step)
        save_and_redirect_to_check_answers
      else
        # this is the mini-loop - it isn't the last step in the section, we have
        # valid data from a previous selection but we choose to take the user
        # through the whole section again.
        next_step = Steps::Helper.next_step_for(session_data, step)
        redirect_to helpers.check_step_path_from_step(next_step, assessment_code)
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

  def step_with_inconsistent_data
    Steps::Helper.remaining_steps_for(session_data, step)
    .drop_while { |thestep|
      Flow::Handler.model_from_session(thestep, session_data).valid?
    }.first
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
