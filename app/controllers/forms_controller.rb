class FormsController < QuestionFlowController
  def update
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      next_step = Steps::Helper.next_step_for(session_data, step)
      calculate_early_result
      if Steps::Helper.cannot_use_service?(session_data, step)
        redirect_to cannot_use_service_path assessment_code:, step:
      elsif next_step
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

  def calculate_early_result
    if last_tag_in_group?(:gross_income)
      cfe_result = CfeService.result(session_data, Steps::Helper.completed_steps_for(session_data, step))
      session_data["early_result"] = { "result" => cfe_result.gross_income_result,
                                       "gross_income_excess" => cfe_result.gross_income_excess,
                                       "type" => "gross_income" }
      if @check.early_ineligible_result?
        track_completed_journey_for_early_result
      end
    end
  end

  def track_completed_journey_for_early_result
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.completed_steps_for(session_data, step))
    calculation_result = CalculationResult.new(session_data)
    office_code = signed_in? && current_provider.present? ? current_provider.first_office_code : nil
    JourneyLoggerService.call(assessment_id, calculation_result, @check, office_code, cookies)
  end
end
