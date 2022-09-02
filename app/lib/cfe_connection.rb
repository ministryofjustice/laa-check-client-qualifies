class CfeConnection
  CFE_HOST = "https://check-financial-eligibility-staging.cloud-platform.service.justice.gov.uk/"

  class << self
    def connection
      Faraday.new(url: CFE_HOST, headers: {"Accept" => "application/json;version=5"}) do |faraday|
        faraday.response :raise_error
      end
    end
  end
end
