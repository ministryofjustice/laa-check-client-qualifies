class ControlledWorkDocumentSelectionsController < ApplicationController
  def new
    # Controlled work form functionality disabled - redirect to end of journey
    redirect_to end_of_journey_path(assessment_code)
  end

  def create
    # Controlled work form functionality disabled - redirect to end of journey
    redirect_to end_of_journey_path(assessment_code)
  end

  def download
    # Controlled work form download functionality disabled - redirect to end of journey
    redirect_to end_of_journey_path(assessment_code)
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def specify_feedback_widget
    @feedback = :freetext
  end
end
