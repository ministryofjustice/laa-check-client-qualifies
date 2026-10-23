class EmbeddedBaseController < ApplicationController
  layout :embedded_layout_path

  skip_before_action :authenticate, :check_maintenance_mode, :specify_feedback_widget, :specify_freetext_feedback_page_name
  after_action :persist_journey_data, if: -> { @session_data_cache.present? }

  rescue_from Cfe::InvalidSessionError do
    log_embedded_event(:warn, event: "embedded.session.invalid", message: "Embedded session invalid",
                              operation: "embedded.session.recover")
    redirect_to :landing
  end

  rescue_from ApplicationController::MissingSessionError do
    log_embedded_event(:warn, event: "embedded.session.missing", message: "Embedded session missing",
                              operation: "embedded.session.recover")
    redirect_to :landing
  end

  around_action :tag_logs_with_resource_id

private

  def log_embedded_event(level, event:, message:, operation:, **context)
    Rails.logger.public_send(level, {
      message:,
      correlationId: request.headers["X-Correlation-ID"].presence || request.request_id,
      context: { event:, operation:, caseId: params[:resource_id] }.merge(context).compact,
    })
  end

  def embedded_layout_path
    layout_path = ModeConfig.embedded_layout
    return layout_path if embedded_layout_exists?(layout_path)

    raise ArgumentError,
          "Unknown embedded layout '#{layout_path}'. Expected app/views/layouts/<layout_path>.html.*"
  end

  def embedded_layout_exists?(layout_path)
    lookup_context.exists?(layout_path, %w[layouts], false)
  end

  def redirect_to_host_reauthentication(location:, operation: "embedded.journey.reauthenticate")
    if location.blank?
      log_embedded_event(:error, event: "embedded.host.redirect_rejected", message: "Host reauthentication redirect rejected",
                                 operation:, dependency: "host-service", statusCode: 302, reason: "missing_location")
      render "errors/service_unavailable", status: :service_unavailable
      return
    end

    uri = URI.parse(location)
    query_params = Rack::Utils.parse_nested_query(uri.query)
    query_params["returnTo"] = host_reauthentication_return_path
    uri.query = query_params.to_query

    unless host_reauthentication_location_allowed?(uri)
      log_embedded_event(:error, event: "embedded.host.redirect_rejected", message: "Host reauthentication redirect rejected",
                                 operation:, dependency: "host-service", statusCode: 302, reason: "disallowed_location")
      render "errors/service_unavailable", status: :service_unavailable
      return
    end

    redirect_to uri.to_s
    log_embedded_event(:info, event: "security.authentication.required", message: "Host reauthentication required",
                              operation:, dependency: "host-service", statusCode: 302)
  rescue URI::InvalidURIError, ActionController::Redirecting::UnsafeRedirectError
    log_embedded_event(:error, event: "embedded.host.redirect_rejected", message: "Host reauthentication redirect rejected",
                               operation:, dependency: "host-service", statusCode: 302, reason: "invalid_location")
    render "errors/service_unavailable", status: :service_unavailable
  end

  def host_reauthentication_location_allowed?(uri)
    return true if uri.host.blank?

    uri.host.casecmp?(request.host)
  end

  def host_reauthentication_return_path
    original_fullpath = request.original_fullpath
    return request.path if original_fullpath.blank?

    uri = URI.parse(original_fullpath)
    destination = Rack::Utils.parse_nested_query(uri.query)["destination"]
    return uri.path if destination.blank?

    "#{uri.path}?#{{ 'destination' => destination }.to_query}"
  rescue URI::InvalidURIError
    request.path
  end

  def journey_store
    @journey_store ||= JourneyDataStore::RedisStore.new(
      params[:resource_id],
      session_id,
    )
  end

  def session_id
    host_service_session_cookies.filter_map { |cookie_name| cookies[cookie_name] }.first
  end

  def host_service_session_cookies
    ENV.fetch("HOST_SERVICE_SESSION_COOKIES", "").split(",").filter_map(&:strip).reject(&:blank?)
  end

  def assessment_code
    params[:resource_id]
  end

  def session_data
    @session_data_cache ||= journey_store.read
  rescue JourneyDataStore::KeyNotFound
    raise ApplicationController::MissingSessionError
  end

  def persist_journey_data
    @journey_data_persisted = journey_store.write(@session_data_cache)
  end

  def tag_logs_with_resource_id(&block)
    Rails.logger.tagged("resource_id:#{params[:resource_id]}", &block)
  end
end
