class EmbeddedLandingsController < EmbeddedBaseController
  RESUMABLE_DESTINATIONS = {
    "check-answers" => :check_answers_path,
    "check-result" => :result_path,
  }.freeze

  prepend_around_action :log_hydrated_journey, only: :show

  def show
    response = HostServiceClient.new.load(
      application_id: params[:resource_id],
      cookies: request.headers["Cookie"],
    )

    case response.status
    when 200
      body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
      if resumable_assessment?(body)
        hydrated = journey_store.write(resumed_journey_data(body)) != false
        redirect_to send(resumable_destination_path_helper, resource_id: params[:resource_id])
        @hydration_event = :resumed if hydrated
      else
        hydrated = journey_store.write(fresh_journey_data(body)) != false
        redirect_to step_path(resource_id: params[:resource_id],
                              step_url_fragment: helpers.step_url_fragment_from_step(Steps::Helper.first_step(session_data)))
        @hydration_event = :started if hydrated
      end
    when 302
      redirect_to_host_reauthentication(
        location: response.headers["location"] || response.headers["Location"],
        operation: "embedded.journey.load",
      )
    when 401
      log_embedded_event(:warn, event: "security.authentication.failed", message: "Host authentication failed",
                                operation: "embedded.journey.load", dependency: "host-service", statusCode: response.status)
      render "errors/session_expired", status: :unauthorized
    when 403
      log_embedded_event(:warn, event: "security.authorisation.denied", message: "Host authorisation denied",
                                operation: "embedded.journey.load", dependency: "host-service", statusCode: response.status)
      render "errors/access_denied", status: :forbidden
    else
      log_embedded_event(:error, event: "embedded.host.request.failed", message: "Host request failed",
                                 operation: "embedded.journey.load", dependency: "host-service", statusCode: response.status, reason: "unexpected_status")
      render "errors/service_unavailable", status: :service_unavailable
    end
  rescue HostServiceClient::ConnectionError
    log_embedded_event(:error, event: "embedded.host.request.failed", message: "Host request failed",
                               operation: "embedded.journey.load", dependency: "host-service", reason: "transport_error")
    render "errors/service_unavailable", status: :service_unavailable
  rescue JourneyDataStore::KeyNotFound
    log_embedded_event(:warn, event: "embedded.session.missing", message: "Embedded session missing",
                              operation: "embedded.session.recover")
    render "errors/session_expired", status: :unauthorized
  end

private

  def log_hydrated_journey
    @hydration_event = nil
    @journey_data_persisted = nil
    yield
    return unless @hydration_event && @journey_data_persisted != false

    log_embedded_event(:info, event: "embedded.journey.#{@hydration_event}",
                              message: @hydration_event == :started ? "Embedded journey started" : "Embedded journey resumed",
                              operation: "embedded.journey.load")
  end

  def resumable_destination_path_helper
    RESUMABLE_DESTINATIONS.fetch(params[:destination], :result_path)
  end

  def resumable_assessment?(body)
    body["data"].is_a?(Hash) && body["result"].is_a?(Hash)
  end

  def resumed_journey_data(body)
    body["data"].merge(
      "api_response" => body["result"],
      "feature_flags" => FeatureFlags.session_flags,
    )
  end

  def fresh_journey_data(body)
    data = {
      "feature_flags" => FeatureFlags.session_flags,
      # Embedded clients are always controlled work and never immigration/asylum matters,
      # so these questions are skipped and pre-filled - see Steps::Helper::EMBEDDED_SKIPPED_STEPS
      "level_of_help" => LevelOfHelpForm::LEVELS_OF_HELP[:controlled],
      "immigration_or_asylum" => false,
    }

    host_data = body["data"]
    client_age = host_data["client_age"] if host_data.is_a?(Hash)
    data["client_age"] = client_age if ClientAgeForm::OPTIONS.include?(client_age)
    data
  end
end
