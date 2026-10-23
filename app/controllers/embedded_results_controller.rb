class EmbeddedResultsController < EmbeddedBaseController
  include QuestionFlowMethods
  before_action :load_check, only: :show

  def create
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.relevant_steps(session_data))
    redirect_to result_path(resource_id: params[:resource_id])
  end

  def early_result_redirect
    @previous_step = params[:step].to_sym
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.completed_steps_for(session_data, @previous_step))
    redirect_to result_path(resource_id: params[:resource_id])
  end

  def show
    @early_result_type = session_data.dig("early_result", "type")
    @model = CalculationResult.new(session_data)
    @embedded_case_path = case_path
    track_page_view(page: :view_results)
    @journey_continues_on_another_page = false # embedded journey always ends here
    render "results/show"
  end

  def complete
    response = HostServiceClient.new.save(
      application_id: params[:resource_id],
      eligibility_assessment: session_data.except("feature_flags", "pending", "early_result"),
      cookies: request.headers["Cookie"],
    )

    case response.status
    when 200
      deleted = journey_store.delete
      @session_data_cache = nil
      redirect_to case_path
      if deleted != false
        log_embedded_event(:info, event: "embedded.journey.completed", message: "Embedded journey completed",
                                  operation: "embedded.journey.save")
      end
    when 302
      redirect_to_host_reauthentication(
        location: response.headers["location"] || response.headers["Location"],
        operation: "embedded.journey.save",
      )
    when 401
      log_embedded_event(:warn, event: "security.authentication.failed", message: "Host authentication failed",
                                operation: "embedded.journey.save", dependency: "host-service", statusCode: response.status)
      render "errors/session_expired", status: :unauthorized
    when 403
      log_embedded_event(:warn, event: "security.authorisation.denied", message: "Host authorisation denied",
                                operation: "embedded.journey.save", dependency: "host-service", statusCode: response.status)
      render "errors/access_denied", status: :forbidden
    else
      log_embedded_event(:error, event: "embedded.host.request.failed", message: "Host request failed",
                                 operation: "embedded.journey.save", dependency: "host-service", statusCode: response.status, reason: "unexpected_status")
      render "errors/service_unavailable", status: :service_unavailable
    end
  rescue HostServiceClient::ConnectionError
    log_embedded_event(:error, event: "embedded.host.request.failed", message: "Host request failed",
                               operation: "embedded.journey.save", dependency: "host-service", reason: "transport_error")
    render "errors/service_unavailable", status: :service_unavailable
  end

  # Reuse the standalone results template and relative partials.
  def self.local_prefixes
    %w[results] + super
  end

private

  # TODO: return to the host service case URL once configurable
  def case_path
    "/cases/#{params[:resource_id]}/task-list"
  end
end
