class EmbeddedLandingsController < EmbeddedBaseController
  def show
    response = HostServiceClient.new.load(
      resource_id: params[:resource_id],
      cookies: request.headers["Cookie"],
    )

    case response.status
    when 200
      body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
      journey_store.init({
        "feature_flags" => FeatureFlags.session_flags,
        "return_url" => body.fetch("return_url"),
      })
      redirect_to step_path(resource_id: params[:resource_id],
                            step_url_fragment: helpers.step_url_fragment_from_step(Steps::Helper.first_step(session_data)))
    when 302
      redirect_to_host_reauthentication(
        location: response.headers["location"] || response.headers["Location"],
      )
    when 401
      Rails.logger.warn(
        "EmbeddedLandingsController received 401 from HostServiceClient: " \
        "status=#{response.status} body_preview=#{host_response_body_preview(response)}",
      )
      render "errors/session_expired", status: :unauthorized
    when 403
      Rails.logger.warn(
        "EmbeddedLandingsController received 403 from HostServiceClient: " \
        "status=#{response.status} body_preview=#{host_response_body_preview(response)}",
      )
      render "errors/access_denied", status: :forbidden
    else
      render "errors/service_unavailable", status: :service_unavailable
    end
  rescue HostServiceClient::ConnectionError
    render "errors/service_unavailable", status: :service_unavailable
  end

private

  def host_response_body_preview(response)
    return "<no-body-method>" unless response.respond_to?(:body)

    body = response.body
    return "<nil>" if body.nil?

    preview = body.is_a?(String) ? body : body.to_json
    preview[0, 300]
  rescue StandardError
    "<unserializable #{response.class}>"
  end
end
