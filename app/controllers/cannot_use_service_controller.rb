class CannotUseServiceController < ApplicationController
  before_action :specify_satisfaction_feedback_page_name

  def additional_properties
    @check = Check.new(session_data)
    @previous_step = previous_step
    track_page_view(page: page_name)
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def previous_step
    params[:step]
  end

  def specify_feedback_widget
    @feedback = :satisfaction
  end

  def specify_satisfaction_feedback_page_name
    @satisfaction_feedback_page_name = page_name
  end

  def page_name
    "cannot-use-service_#{previous_step}"
  end
end
