class ChangeAnswersController < QuestionFlowController
  before_action :set_back_behaviour

  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      if Steps::Helper.last_step_in_group?(session_data, step)
        next_step = next_check_answer_step(step)
        if FeatureFlags.enabled?(:early_eligibility, session_data)
          last_step_with_data = Steps::Helper.last_step_with_valid_data(session_data)
          completed_steps = Steps::Helper.completed_steps_for(session_data, last_step_with_data)
          if non_finance_step?(step)
            if last_non_finance_step?(last_step_with_data)
              cfe_result = CfeService.result(session_data, completed_steps)
              if cfe_result.ineligible_gross_income?
                next_step = nil
              elsif next_step.present? && !non_finance_step?(next_step) && Steps::Logic.check_stops_at_gross_income?(session_data)
                flash[:notice] = I18n.t("service.change_eligibility")
              end
            end
          else
            cfe_result = CfeService.result(session_data, completed_steps)
            # need to check for partner false, otherwise the flow stops here with a partner even though we have not shown an interruption
            # screen in that scenario (as the flow hasn't been built yet)
            if Steps::Logic.data_stops_before_outgoings?(session_data) && !Steps::Logic.partner?(session_data) && cfe_result.ineligible_gross_income?
              next_step = nil
            end
            if Steps::Logic.data_stops_before_outgoings?(session_data) && !cfe_result.ineligible_gross_income? && next_step.present?
              session_data.delete IneligibleGrossIncomeForm::SELECTION
              flash[:notice] = I18n.t("service.change_eligibility")
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

  def last_non_finance_step?(the_step)
    non_finance_steps = Steps::Helper.steps_for_section(session_data, Steps::CaseDetailsSection) +
      Steps::Helper.steps_for_section(session_data, Steps::ApplicantDetailsSection)
    non_finance_steps.last == the_step || the_step == :other_income
  end

  def non_finance_step?(the_step)
    (Steps::Helper.steps_for_section(session_data, Steps::ApplicantDetailsSection) +
      Steps::Helper.steps_for_section(session_data, Steps::CaseDetailsSection)).include?(the_step)
  end
end
