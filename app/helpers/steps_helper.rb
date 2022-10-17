module StepsHelper
  def previous_step_for(estimate, step)
    Screens::PreviousScreenNameService.call(estimate, step)
  end
end
