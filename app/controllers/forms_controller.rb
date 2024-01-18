class FormsController < QuestionFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      if FeatureFlags.enabled?(:early_eligibility, session_data) && last_tag_in_group?(:gross_income)
        # we actually might not need to send down the early eligibility argument if we just check the form validity?
        session_data["early_result"] = CfeService.call(session_data, early_eligibility: :gross_income)
      end
      next_step = Steps::Helper.next_step_for(session_data, step)
      if show_early_result_screen?
        redirect_to early_result_path(assessment_code, step:, early_result_type: :gross_income)
      elsif next_step && !show_early_result_screen?
        redirect_to helpers.step_path_from_step(next_step, assessment_code)
      else
        redirect_to check_answers_path assessment_code:
      end
    else
      track_validation_error
      render "question_flow/#{step}"
    end
  end

  def show_early_result_screen?
    FeatureFlags.enabled?(:early_eligibility, session_data) && Steps::Logic.ineligible_gross_income?(session_data) && last_tag_in_group?(:gross_income)
  end
end
