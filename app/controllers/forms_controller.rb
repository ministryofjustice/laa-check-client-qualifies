class FormsController < QuestionFlowController
  def update
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      next_step = calculate_next_step(session_data, step)
      if next_step
        redirect_to helpers.step_path_from_step(next_step, assessment_code)
      else
        redirect_to check_answers_path assessment_code:
      end
    else
      track_validation_error
      render "question_flow/#{step}"
    end
  end

private

  def calculate_next_step(session_data, step)
    if FeatureFlags.enabled?(:early_eligibility, session_data)
      if step == :ineligible_gross_income
        if Steps::Logic.user_chose_to_continue_check?(session_data)
          Steps::Helper.next_step_for(session_data, Steps::Helper.last_step_for_section(session_data, :income_section))
        end
      elsif last_tag_in_group?(:gross_income) && CfeService.result(session_data, Steps::Helper.completed_steps_for(session_data, step)).ineligible_gross_income?
        :ineligible_gross_income
      else
        Steps::Helper.next_step_for(session_data, step)
      end
    else
      Steps::Helper.next_step_for(session_data, step)
    end
  end
end
