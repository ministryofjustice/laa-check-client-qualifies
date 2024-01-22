class EarlyResultsController < ApplicationController
  before_action :load_check,
                :set_back_behaviour

  def show; end

  def resume_check
    session_data["resume_check"] = true
    if session_data["next_step"]
      redirect_to helpers.step_path_from_step(session_data["next_step"], assessment_code)
    else
      redirect_to check_answers_path(assessment_code)
    end
  end

private

  def assessment_code
    params[:assessment_code].presence
  end

  def load_check
    @check = Check.new(session_data)
  end

  def set_back_behaviour
    @back_buttons_invoke_browser_back_behaviour = true
  end
end
