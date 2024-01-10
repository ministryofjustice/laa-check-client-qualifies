class EarlyEligibilitiesController < FormsController
  def gross_income
    @next_step = Steps::Helper.next_step_for(session_data, step)
  end
end
