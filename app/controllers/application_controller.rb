class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  def create_assessment_id
    create_request = {
      client_reference_id: "LA-FOO-BAR",
      submission_date: Time.zone.today
    }
    response = cfe_connection.post("assessments", create_request.to_json)
    result = JSON.parse(response.body).symbolize_keys
    result.fetch(:assessment_id).tap do |assassment_id|
      proceeding_types = {
        proceeding_types: [
          {
            ccms_code: "DA001",
            client_involvement_type: "A"
          },
          {
            ccms_code: "SE013",
            client_involvement_type: "I"
          }
        ]
      }

      create_record(assassment_id, "proceeding_types", proceeding_types)
    end
  end

  def create_record assessment_id, record_type, record_data
    response = cfe_connection.post "/assessments/#{assessment_id}/#{record_type}", record_data.to_json
    JSON.parse(response.body).symbolize_keys
  end

  def api_result assessment_id
    response = cfe_connection.get "/assessments/#{assessment_id}"
    JSON.parse(response.body).deep_symbolize_keys
  end

  private

  def cfe_connection
    @cfe_connection ||= CfeConnection.connection
  end
end
