class FormsController < QuestionFlowController
  def update
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.model_from_params(step, params, session_data)

    if @form.valid?
      track_choices(@form)
      session_data.merge!(@form.attributes_for_export_to_session)
      next_step = if FeatureFlags.enabled?(:ee_banner, session_data)
                    Steps::Helper.next_step_for(session_data, step)
                  else
                    calculate_next_step(session_data, step)
                  end
      calculate_early_result if FeatureFlags.enabled?(:ee_banner, session_data)
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
    if step == :ineligible_gross_income
      if Steps::Logic.user_chose_to_continue_check?(session_data)
        Steps::Helper.next_step_for(session_data, Steps::Helper.last_step_for_section(session_data, :income_section))
      end
    elsif last_tag_in_group?(:gross_income) && CfeService.result(session_data, Steps::Helper.completed_steps_for(session_data, step)).ineligible_gross_income?
      :ineligible_gross_income
    else
      Steps::Helper.next_step_for(session_data, step)
    end
  end

  def calculate_early_result
    if last_tag_in_group?(:gross_income)
      cfe_result = CfeService.result(session_data, Steps::Helper.completed_steps_for(session_data, step))
      session_data["early_result"] = { "result" => cfe_result.gross_income_result,
                                       "gross_income_excess" => cfe_result.gross_income_excess,
                                       "type" => "gross_income" } # I think we have to set this here so we have it in the session, when calling the `JourneyLoggerService`
      track_completed_journey_for_early_result
    end
  end

  def track_completed_journey_for_early_result
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.completed_steps_for(session_data, step))
    calculation_result = CalculationResult.new(session_data)
    office_code = signed_in? && current_provider.present? ? current_provider.first_office_code : nil
    assessment_id_with_early_result_suffix = "#{assessment_id}_early_result" # This is so we do not overrite newly created early result entry, if an user decides to carry on with check or change answers
    JourneyLoggerService.call(assessment_id_with_early_result_suffix, calculation_result, @check, office_code, cookies)
  end
end
