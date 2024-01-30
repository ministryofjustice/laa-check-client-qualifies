class FormsController < QuestionFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      strategy = Strategy::FormHandlerStrategy.new
      if FeatureFlags.enabled?(:early_eligibility, session_data)
        strategy = Strategy::EarlyEligibilityStrategy.new strategy
      end
      # if FeatureFlags.enabled?(:early_eligibility, session_data) && last_tag_in_group?(:gross_income)
      #   session_data["gross_early_result"] = CfeService.cfe_result(CfeService.call(session_data, early_eligibility: :gross_income))
      # end
      # next_step = Steps::Helper.next_step_for(session_data, step)
      next_step = strategy.next_step session_data, step
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
end
