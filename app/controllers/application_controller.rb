class ApplicationController < ActionController::Base
  BROWSER_ID_COOKIE = :browser_id
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

private

  def session_data(id = estimate_id)
    session[session_key(id)] ||= {}
  end

  def session_key(id)
    "estimate_#{id}"
  end

  def track_page_view(assessment_id: nil, page: page_name)
    track("page_view", assessment_id:, page:)
  end

  def track_validation_error(assessment_id: nil, page: page_name)
    track("validation_message", assessment_id:, page:)
    track_page_view(assessment_id:, page:)
  end

  def track(event_type, assessment_id:, page:)
    AnalyticsService.call(event_type:,
                          browser_id: cookies[BROWSER_ID_COOKIE],
                          assessment_id:,
                          page:)
  end

  def page_name
    "#{action_name}_#{controller_name}"
  end
end
