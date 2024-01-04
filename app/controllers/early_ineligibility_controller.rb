class EarlyIneligibilityController < FormsController
  def show
    @next_step = Steps::Helper.next_step_for(session_data, step)
    session_data["early_result_screen_seen"] = true
  end
end
