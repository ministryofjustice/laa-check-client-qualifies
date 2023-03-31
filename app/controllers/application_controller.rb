class ApplicationController < ActionController::Base
  BROWSER_ID_COOKIE = :browser_id
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

private

  def assessment_id
    Digest::SHA256.hexdigest(assessment_code + (cookies["SessionData"] || ""))
  end

  # When the session is redis-backed, numeric values get silently turned into strings.
  # To counter this, we store session data as a JSON string
  def session_data
    session[assessment_id] ||= "{}"
    JSON.parse(session[assessment_id])
  end

  def write_session_data(new_data)
    session[assessment_id] = session_data.merge(new_data).to_json
  end

  def track_page_view(page: page_name)
    track("page_view", page:)
  end

  def track_validation_error(page: page_name)
    track("validation_message", page:)
    track_page_view(page:)
  end

  def track(event_type, page:)
    AnalyticsService.call(event_type:,
                          browser_id: cookies[BROWSER_ID_COOKIE],
                          assessment_code:,
                          page:)
  end

  def assessment_code
    nil
  end

  def page_name
    "#{action_name}_#{controller_name}"
  end
end
