class FormsController < QuestionFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      check_early_gross_income_eligiblity
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

  def check_early_gross_income_eligiblity
    # get all the steps for this check, which steps apply
    # we have added a tag in the flow handler to determine which steps are related to income
    # look at the steps remaining
    # if no gross income tags remain, check eligibility
    remaining_steps = Steps::Helper.remaining_steps_for(session_data, step)

    remaining_tags = []
    remaining_steps.map do |remaining|
      remaining_tags << Flow::Handler::STEPS.fetch(remaining)[:tag]
    end
    return unless !remaining_tags.compact.include?(:gross_income) && Flow::Handler::STEPS.fetch(step)[:tag] == :gross_income

    session_data["api_result"] = CfeService.call(session_data, early_eligibility: true)
  end
end
