class HostServiceClient
  class ConnectionError < StandardError; end

  CONNECT_TIMEOUT = 2
  READ_TIMEOUT = 5

  def load(resource_id:, cookies:)
    get(ENV.fetch("HOST_SERVICE_LOAD_ENDPOINT", "/api/private/load").to_s, { resource_id: }, cookies:)
  end

  def save(resource_id:, result:, cookies:)
    post(ENV.fetch("HOST_SERVICE_SAVE_ENDPOINT", "/api/private/save").to_s, { resource_id:, result: }, cookies:)
  end

private

  def get(path, params, cookies:)
    response = connection(cookies:).get(path, params)
    Rails.logger.info("[HostServiceClient] GET #{path} status=#{response.status} body_preview=#{body_preview(response.body)}")
    response
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    raise ConnectionError, e.message
  end

  def post(path, body, cookies:)
    response = connection(cookies:).post(path, body)
    Rails.logger.info("[HostServiceClient] POST #{path} status=#{response.status} body_preview=#{body_preview(response.body)}")
    response
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    raise ConnectionError, e.message
  end

  def connection(cookies:)
    Faraday.new(url: ENV.fetch("HOST_SERVICE_URL")) do |faraday|
      faraday.options.open_timeout = CONNECT_TIMEOUT
      faraday.options.timeout = READ_TIMEOUT
      faraday.headers["Cookie"] = cookies if cookies.present?
      faraday.request :json
      faraday.response :json
      faraday.adapter :net_http_persistent
    end
  end

  def body_preview(body)
    return "<nil>" if body.nil?

    preview = body.is_a?(String) ? body : body.to_json
    preview[0, 300]
  rescue StandardError
    "<unserializable #{body.class}>"
  end
end
