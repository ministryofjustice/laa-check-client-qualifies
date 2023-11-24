class FormsController < QuestionFlowController
  def update
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      # if tags_from(step).include?(:gross_income)
      #   session_data["api_result"] = CfeService.call(session_data, early_eligibility: :gross_income)
      # end

      if tags_from(step).include?(:employment_income)
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: :employment_income)
      end

      if tags_from(step).include?(:benefits_income)
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: :benefits_income)
      end

      if tags_from(step).include?(:other_income)
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: :other_income)
      end

      if tags_from(step).include?(:partner_employment_income)
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: :partner_employment_income)
      end

      if tags_from(step).include?(:partner_benefits_income)
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: :partner_benefits_income)
      end

      if tags_from(step).include?(:partner_other_income)
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: :partner_other_income)
      end

      if tags_from(step).include?(:disposable_income)
        check_early_disposable_income_eligibility(session_data, step)
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

  def check_early_disposable_income_eligibility(session_data, step)
    remaining_steps = Steps::Helper.remaining_steps_for(session_data, step)
    return if remaining_steps.blank?

    remaining_tags = []
    remaining_steps.map do |remaining|
      remaining_tags << tags_from(remaining)
    end
    return unless !remaining_tags.flatten.compact.include?(:disposable_income) && tags_from(step).include?(:disposable_income)

    session_data["disposable_income_early_result"] = CfeService.call(session_data, early_eligibility: :disposable_income)
  end
end
