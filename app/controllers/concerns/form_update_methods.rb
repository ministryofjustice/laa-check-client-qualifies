module FormUpdateMethods
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
    JourneyLoggerService.call(assessment_id, calculation_result, @check, cookies)
  end
end
