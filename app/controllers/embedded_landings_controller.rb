class EmbeddedLandingsController < EmbeddedBaseController
  def show
    response = HostServiceClient.new.load(
      application_id: params[:resource_id],
      cookies: request.headers["Cookie"],
    )

    case response.status
    when 200
      body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
      if resumable_assessment?(body)
        journey_store.init(resumed_journey_data(body))
        redirect_to result_path(resource_id: params[:resource_id])
      else
        journey_store.init({
          "feature_flags" => FeatureFlags.session_flags,
        })
        redirect_to step_path(resource_id: params[:resource_id],
                              step_url_fragment: helpers.step_url_fragment_from_step(Steps::Helper.first_step(session_data)))
      end
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

  def resumable_assessment?(body)
    body["data"].is_a?(Hash) && body["result"].is_a?(Hash)
  end

  def resumed_journey_data(body)
    body["data"].merge(
      "api_response" => body["result"],
      "feature_flags" => FeatureFlags.session_flags,
    )
  end

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
