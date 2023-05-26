class ApplicationController < ActionController::Base
  BROWSER_ID_COOKIE = :browser_id
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder
  before_action :force_setting_of_session_cookie

  class MissingSessionError < StandardError; end

  rescue_from MissingSessionError do
    render "errors/missing_session"
  end

private

  def assessment_id(code = assessment_code)
    Digest::SHA256.hexdigest(code + (cookies["SessionData"] || ""))
  end

  def session_data
    session[assessment_id].tap { raise MissingSessionError if _1.nil? }
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
                          cookies:,
                          assessment_code:,
                          page:)
  end

  def assessment_code
    nil
  end

  def page_name
    "#{action_name}_#{controller_name}"
  end

  def force_setting_of_session_cookie
    session["arbitrary_key"] = "arbitrary_value"
  end
end
