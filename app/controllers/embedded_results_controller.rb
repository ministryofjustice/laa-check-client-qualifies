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
    track_page_view(page: :view_results)
    @journey_continues_on_another_page = false # embedded journey always ends here
    render "results/show"
  end

  def complete
    response = HostServiceClient.new.save(
      resource_id: params[:resource_id],
      result: session_data["api_response"],
      cookies: request.headers["Cookie"],
    )

    case response.status
    when 200
      return_url = session_data["return_url"]
      raise "Missing return_url in journey data" if return_url.blank?

      allowed_hosts = ENV.fetch("ALLOWED_RETURN_HOSTS", "").split(",").map(&:strip)
      unless allowed_hosts.empty?
        uri = URI.parse(return_url)
        unless allowed_hosts.include?(uri.host)
          render "errors/access_denied", status: :forbidden
          return
        end
      end

      journey_store.delete # clean up Redis
      @session_data_cache = nil
      redirect_to return_url, allow_other_host: true
    when 401
      render "errors/session_expired", status: :unauthorized
    when 403
      render "errors/access_denied", status: :forbidden
    else
      render "errors/service_unavailable", status: :service_unavailable
    end
  rescue HostServiceClient::ConnectionError
    render "errors/service_unavailable", status: :service_unavailable
  end

  # Reuse the standalone results template and relative partials.
  def self.local_prefixes
    %w[results] + super
  end
end
