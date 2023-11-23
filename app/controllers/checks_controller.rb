class ChecksController < ApplicationController
  before_action :redirect_to_primary_host, only: :new

  def new
    new_assessment_code = SecureRandom.uuid
    data = { "feature_flags" => FeatureFlags.session_flags }
    session[assessment_id(new_assessment_code)] = data
    redirect_to helpers.step_path_from_step(Steps::Helper.first_step(data), new_assessment_code)
  end

  def check_answers
    if params[:hide_widget]
      session_data["skip_to_check_answers"] = true
    end
    @check = Check.new(session_data)
    @sections = CheckAnswers::SectionListerService.call(session_data)
    track_page_view(page: :check_answers)
  end

  def end_of_journey
    @model = CalculationResult.new(session_data)
    @check = Check.new(session_data)
    @form = ControlledWorkDocumentSelection.from_session(session_data)
    track_page_view(page: :end_of_journey)
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def specify_feedback_widget
    @feedback = action_name == "end_of_journey" ? :satisfaction : :freetext
  end
end
