# spec/services/civil_case_api_service_spec.rb
require 'rails_helper'
require 'civil_case_api_service'


RSpec.describe CivilCaseApiService, type: :service do
  let(:assessment_id) { '12345' }
  let(:token) { 'fake_token' }
  let(:session_data) { { "key" => "value" } }

  before do
    stub_request(:post, "https://www.staging.civil-case-api.cloud-platform.service.justice.gov.uk/token")
      .to_return(
        status: 200,
        body: { access_token: token }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:get, "https://www.staging.civil-case-api.cloud-platform.service.justice.gov.uk/cases/#{assessment_id}/session_data")
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(
        status: 200,
        body: { session_data: session_data }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:post, "https://www.staging.civil-case-api.cloud-platform.service.justice.gov.uk/cases/#{assessment_id}/session_data")
      .with(
        headers: { 'Authorization' => "Bearer #{token}" },
        body: { session_data: session_data }.to_json
      )
      .to_return(status: 200, body: "", headers: {})
  end

  describe '.fetch_session_data' do
    it 'fetches session data from the API' do
      result = CivilCaseApiService.fetch_session_data(assessment_id)
      expect(result).to eq(session_data)
    end
  end

  describe '.save_session_data' do
    it 'saves session data to the API' do
      expect {
        CivilCaseApiService.save_session_data(assessment_id, session_data)
      }.not_to raise_error
    end
  end
end
