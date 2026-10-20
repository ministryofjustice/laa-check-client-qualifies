class HostServiceClient
  class ConnectionError < StandardError; end

  CONNECT_TIMEOUT = 2
  READ_TIMEOUT = 5

  def load(application_id:, cookies:)
    get(eligibility_path(application_id), {}, cookies:)
  end

  def save(application_id:, eligibility_assessment:, cookies:)
    put(eligibility_path(application_id), { eligibility_assessment: }, cookies:)
  end

private

  def eligibility_path(application_id)
    sprintf(ENV.fetch("HOST_SERVICE_ELIGIBILITY_ENDPOINT", "/api/applications/%<application_id>s/eligibility").to_s, application_id:)
  end

  def get(path, params, cookies:)
    connection(cookies:).get(path, params)
  rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
    raise ConnectionError, e.message
  end

  def put(path, body, cookies:)
    connection(cookies:).put(path, body)
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
