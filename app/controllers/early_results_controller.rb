class EarlyResultsController < FormsController
  def show
    @next_step = Steps::Helper.next_step_for(session_data, step)
    @early_result_type = tag_from(step)
  end
end
