class ApplicationController < ActionController::Base
  BROWSER_ID_COOKIE = :browser_id
  BASIC_AUTHENTICATION_COOKIE = :basic_authenticated
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder
  before_action :force_setting_of_session_cookie,
                :specify_feedback_widget,
                :specify_freetext_feedback_page_name,
                :authenticate,
                :check_maintenance_mode,
                :ensure_db_connection

  class MissingSessionError < StandardError; end

  rescue_from MissingSessionError do
    @feedback = :freetext
    @freetext_feedback_page_name = "missing_session"
    render "errors/missing_session"
  end

  rescue_from Cfe::InvalidSessionError do |e|
    ErrorService.call(e)
    render "errors/invalid_session"
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

  # The session cookie doesn't get set until a session value gets set
  # This presents a problem as we use the session cookie value
  # to generate the assessment id from the assessment code.
  # Particularly in the test environment, which uses a new session for every
  # spec, this presents a problem. So we solve this by ensuring we
  # set a session value right away to trigger the session cookie creation
  def force_setting_of_session_cookie
    session["arbitrary_key"] ||= ""
  end

  def redirect_to_primary_host
    return if ENV["PRIMARY_HOST"].blank? || ENV["PRIMARY_HOST"] == request.host

    redirect_to [request.protocol, ENV["PRIMARY_HOST"], request.fullpath].join, allow_other_host: true
  end

  def check_maintenance_mode
    if FeatureFlags.enabled?(:maintenance_mode, without_session_data: true)
      render file: "public/maintenance.html", layout: false
    end
  end

  def authenticate
    return unless FeatureFlags.enabled?(:basic_authentication, without_session_data: true)

    # MOJ DOM1 laptops have HTTP Basic Authentication disabled in Edge, so we provide our own
    # 'basic authentication' UI
    if cookies.signed[BASIC_AUTHENTICATION_COOKIE]
      session["user_return_to"] = nil
    else
      session["user_return_to"] = request.path
      redirect_to new_basic_authentication_session_path
    end
  end

  def after_sign_in_path_for(*)
    rails_admin_path
  end

  def specify_feedback_widget
    @feedback = :freetext
  end

  def specify_freetext_feedback_page_name
    @freetext_feedback_page_name = page_name
  end

  def ensure_db_connection
    # In some circumstances the database connection can be interrupted, and when this happens
    # even when the database is available again, the connection is not restored automatically
    # This check ensures the connection is restored as soon as possible if this ever happens
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
  rescue StandardError
    nil
  end
end
