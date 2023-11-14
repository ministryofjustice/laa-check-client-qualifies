class FormsController < QuestionFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      remaining_steps = Steps::Helper.remaining_steps_for(session_data, step)
      if remaining_steps
        check_early_eligiblity(remaining_steps, :gross_income)
        check_early_eligiblity(remaining_steps, :disposable_income)
      end
      next_step = Steps::Helper.next_step_for(session_data, step)
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

  def check_early_eligiblity(steps, tag)
    remaining_tags = []
    steps.map do |remaining|
      remaining_tags << tag_from(remaining)
    end
    return unless !remaining_tags.compact.include?(tag) && tag_from(step) == tag

    session_data["api_result"] = CfeService.call(session_data, early_eligibility: tag)
  end

  # def check_early_disposable_income_eligibility
  #   remaining_steps = Steps::Helper.remaining_steps_for(session_data, step)

  #   remaining_tags = []
  #   remaining_steps.map do |remaining|
  #     remaining_tags << Flow::Handler::STEPS.fetch(remaining)[:tag]
  #   end
  #   return unless !remaining_tags.compact.include?(:disposable_income) && Flow::Handler::STEPS.fetch(step)[:tag] == :disposable_income

  #   session_data["api_result"] = CfeService.call(session_data, early_eligibility: :disposable_income)
  # end
end
