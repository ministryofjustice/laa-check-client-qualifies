class ChangeAnswersController < QuestionFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      if Steps::Helper.last_step_in_group?(session_data, step)
        last_step_with_data = Steps::Helper.last_step_with_valid_data(session_data)
        next_step = next_check_answer_step(step)
        if FeatureFlags.enabled?(:early_eligibility, session_data)
          if step_in_applicant_or_case_details?(step)
            if is_last_step_in_applicant_case_details?(last_step_with_data) && CfeService.ineligible_gross_income?(session_data, Steps::Helper.completed_steps_for(session_data, last_step_with_data))
              next_step = nil
            else
              flash[:notice] = "Based on the answers you changed, your client is now within the limit for legal aid. Add more details and find out if they would still qualify."
            end
          else
            if Steps::Logic.check_stops_at_gross_income?(session_data) && CfeService.ineligible_gross_income?(session_data, Steps::Helper.completed_steps_for(session_data, last_step_with_data))
              next_step = nil
            end
            if show_flash(session_data, last_step_with_data)
              flash[:notice] = "Based on the answers you changed, your client is now within the limit for legal aid. Add more details and find out if they would still qualify."
            end
          end
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

  def is_last_step_in_applicant_case_details?(the_step)
    non_finance_steps = Steps::Helper.steps_for_section(session_data, Steps::CaseDetailsSection) +
      Steps::Helper.steps_for_section(session_data, Steps::ApplicantDetailsSection)
    non_finance_steps.last == the_step || the_step == :other_income
  end

  def step_in_applicant_or_case_details?(the_step)
    (Steps::Helper.steps_for_section(session_data, Steps::ApplicantDetailsSection) +
      Steps::Helper.steps_for_section(session_data, Steps::CaseDetailsSection)).include?(the_step)
    # if they change the level of help, we don't want to send to CFE because we need the proceeding (matter) type first
    # same goes for client age as I don't think we would have the right payload needed for CFE response until second step
    # also if the answer is changed to 'no' for domestic abuse applicant as we need to ask the I&A q (matter type) before we send to CFE
  end

  def show_flash(session_data, last_step_with_data)
    return false unless Steps::Logic.check_stops_at_gross_income?(session_data)

    return false if CfeService.ineligible_gross_income?(session_data, Steps::Helper.completed_steps_for(session_data, last_step_with_data))

    true
  end
end
