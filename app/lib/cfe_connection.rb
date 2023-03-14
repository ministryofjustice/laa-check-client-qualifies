class CfeConnection
  CFE_HOST = Rails.configuration.check_financial_eligibility_host

  class << self
    def connection
      CfeConnection.new
    end
  end

  def status
    response = cfe_connection.get("healthcheck")
    response.body.deep_symbolize_keys.fetch(:checks)
  end

  def state_benefit_types
    cfe_connection.get("state_benefit_type").body
  rescue StandardError
    []
  end

  def create_assessment_id(attributes)
    response = cfe_connection.post("assessments", attributes)
    response.body.symbolize_keys.fetch(:assessment_id)
  end

  def create_proceeding_types(assessment_id, proceeding_types)
    create_record(assessment_id, "proceeding_types", proceeding_types:)
  end

  def create_applicant(assessment_id, applicant)
    create_record(assessment_id, "applicant", applicant:)
  end

  def create_dependants(assessment_id, dependants)
    create_record(assessment_id, "dependants", dependants:)
  end

  def create_irregular_incomes(assessment_id, payments)
    create_record(assessment_id, "irregular_incomes", payments:)
  end

  def create_employments(assessment_id, employment_income)
    create_record(assessment_id, "employments", employment_income:)
  end

  def create_regular_transactions(assessment_id, regular_transactions)
    create_record(assessment_id, "regular_transactions", regular_transactions:)
  end

  def create_state_benefits(assessment_id, state_benefits)
    create_record(assessment_id, "state_benefits", state_benefits:)
  end

  def create_properties(assessment_id, properties)
    create_record(assessment_id, "properties", properties:)
  end

  def create_capitals(assessment_id, capital_params)
    create_record(assessment_id, "capitals", capital_params)
  end

  def create_vehicles(assessment_id, vehicles)
    create_record(assessment_id, "vehicles", vehicles:)
  end

  def create_partner_financials(assessment_id, partner_params)
    create_record(assessment_id, "partner_financials", partner_params)
  end

  def api_result(assessment_id)
    url = "/assessments/#{assessment_id}"
    response = cfe_connection.get url
    validate_api_response(response, url)
    CalculationResult.new(response.body.deep_symbolize_keys)
  end

private

  def create_record(assessment_id, record_type, record_data)
    url = "/assessments/#{assessment_id}/#{record_type}"
    response = cfe_connection.post url, record_data
    validate_api_response(response, url)
  end

  def validate_api_response(response, url)
    return if response.success?

    raise "Call to CFE url #{url} returned status #{response.status} and message:\n#{response.body}"
  end

  def cfe_connection
    @cfe_connection ||= Faraday.new(url: CFE_HOST, headers: { "Accept" => "application/json;version=5" }) do |faraday|
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
end
