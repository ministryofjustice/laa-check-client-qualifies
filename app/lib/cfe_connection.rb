class CfeConnection
  CFE_HOST = "https://check-financial-eligibility-staging.cloud-platform.service.justice.gov.uk/".freeze

  class << self
    def connection
      CfeConnection.new
    end
  end

  def create_assessment_id
    create_request = {
      submission_date: Time.zone.today,
    }
    response = cfe_connection.post("assessments", create_request)
    response.body.symbolize_keys.fetch(:assessment_id).tap do |assessment_id|
      proceeding_types = {
        proceeding_types: [
          {
            ccms_code: "DA001",
            client_involvement_type: "A",
          },
          {
            ccms_code: "SE013",
            client_involvement_type: "I",
          },
        ],
      }

      create_record(assessment_id, "proceeding_types", proceeding_types)
    end
  end

  def create_applicant(assessment_id, date_of_birth:, receives_qualifying_benefit:)
    applicant = {
      date_of_birth:,
      has_partner_opponent: false,
      receives_qualifying_benefit:,
    }
    create_record(assessment_id, "applicant", applicant:)
  end

  def api_result(assessment_id)
    response = cfe_connection.get "/assessments/#{assessment_id}"
    response.body.deep_symbolize_keys
  end

private

  def create_record(assessment_id, record_type, record_data)
    cfe_connection.post "/assessments/#{assessment_id}/#{record_type}", record_data
  end

  def cfe_connection
    @cfe_connection ||= Faraday.new(url: CFE_HOST, headers: { "Accept" => "application/json;version=5" }) do |faraday|
      faraday.request :json
      faraday.response :raise_error
      faraday.response :json
    end
  end
end
