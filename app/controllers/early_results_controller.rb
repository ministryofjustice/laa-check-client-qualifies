class EarlyResultsController
  def show; end

  def resume_check
    session_data["resume_check"] = true
    redirect_to step_path_from_step(@next_step, params[:assessment_code])
  end
end
