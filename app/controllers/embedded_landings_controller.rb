class EmbeddedLandingsController < EmbeddedBaseController
  def show
    response = HostServiceClient.new.load(
      resource_id: params[:resource_id],
      cookies: request.headers["Cookie"],
    )

    case response.status
    when 200
      body = JSON.parse(response.body)
      journey_store.init({
        "feature_flags" => FeatureFlags.session_flags,
        "return_url" => body.fetch("return_url"),
      })
      redirect_to step_path(resource_id: params[:resource_id],
                            step_url_fragment: helpers.step_url_fragment_from_step(Steps::Helper.first_step(session_data)))
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
end
