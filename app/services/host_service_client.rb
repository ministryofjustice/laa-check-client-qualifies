class HostServiceClient
  class ConnectionError < StandardError; end

  CONNECT_TIMEOUT = 2
  READ_TIMEOUT = 5

  def load(resource_id:, cookies:)
    post(ENV.fetch("HOST_SERVICE_LOAD_ENDPOINT", "/api/private/load").to_s, { resource_id: }, cookies:)
  end

  def save(resource_id:, result:, cookies:)
    post(ENV.fetch("HOST_SERVICE_SAVE_ENDPOINT", "/api/private/save").to_s, { resource_id:, result: }, cookies:)
  end

private

  def post(path, body, cookies:)
    connection(cookies:).post(path, body)
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
end
