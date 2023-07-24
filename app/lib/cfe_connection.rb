class CfeConnection
  CFE_HOST = Rails.configuration.check_financial_eligibility_host

  class << self
    def state_benefit_types
      cfe_connection.get("state_benefit_type").body
    rescue StandardError
      []
    end

    def assess(payload)
      response = cfe_connection.post "v6/assessments", format_json(payload)
      validate_api_response(response)
      response.body
    end

  private

    def validate_api_response(response)
      return if response.success?

      raise "Call to CFE returned status #{response.status} and message:\n#{response.body}"
    end

    def cfe_connection
      Faraday.new(url: CFE_HOST, headers: { "Accept" => "application/json", "User-Agent" => user_agent_string }) do |faraday|
        faraday.request :json

        # retry 502 errors from CFE requests. Some 502 requests don't return valid JSOn so we get Faraday::ParsingError
        # thrown, so we have to add that to the list of exceptions to be handled on retries
        faraday.request :retry, max: 3, interval: 0.05,
                                interval_randomness: 0.5, backoff_factor: 2,
                                retry_statuses: [502, 504],
                                exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Faraday::ParsingError],
                                methods: Faraday::Retry::Middleware::IDEMPOTENT_METHODS + [:post]

        # response middleware is supposed to be registered after request middleware
        faraday.response :json

        faraday.adapter :net_http_persistent
      end
    end

    def format_json(hash)
      # BigDecimal#as_json returns a string, and we want numbers to be sent to
      # CFE as numbers. So we seek out all decimals and convert them to floats
      # as we build the payload.
      hash.deep_transform_values do |value|
        value.is_a?(BigDecimal) ? value.to_f : value
      end
    end

    def user_agent_string
      commit_hash = if File.exist?(Rails.root.join("VERSION"))
                      File.read(Rails.root.join("VERSION"))
                    else
                      `git rev-parse --short HEAD`
                    end
      environment_name = ENV.fetch("CFE_ENVIRONMENT_NAME", "local")
      "ccq/#{commit_hash.chomp} (#{environment_name})"
    end
  end
end
