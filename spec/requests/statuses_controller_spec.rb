require "rails_helper"

RSpec.describe "status requests" do
  let(:response_json) { JSON.parse(response.body) }

  describe "GET /status" do
    it "is successful and alive returns true" do
      get("/status")
      expect(response).to be_successful
      expect(response_json).to eq("alive" => true)
    end
  end

  describe "GET /health-including-dependents" do
    it "is successful and alive returns true by default" do
      stub_request(:get, "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/healthcheck")
         .to_return(status: 200, body: { checks: { database: true } }.to_json, headers: { "Content-Type" => "application/json" })
      get("/health-including-dependents")
      expect(response).to be_successful
      expect(response_json).to eq("healthy" => true)
    end

    it "returns false if there is a problem writing to the cache" do
      allow(Rails.cache).to receive(:write).and_return(false)
      get("/health-including-dependents")
      expect(response).not_to be_successful
    end

    it "returns false if there is a problem reading from the cache" do
      allow(Rails.cache).to receive(:read).and_return(nil)
      get("/health-including-dependents")
      expect(response).not_to be_successful
    end

    it "returns false if there is a problem reported by CFE" do
      stub_request(:get, "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/healthcheck")
         .to_return(status: 200, body: { checks: { database: false } }.to_json, headers: { "Content-Type" => "application/json" })
      get("/health-including-dependents")
      expect(response).not_to be_successful
    end

    it "returns false if CFE does not respond as expected" do
      stub_request(:get, "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/healthcheck")
         .to_return(status: 200, body: { checks: {} }.to_json, headers: { "Content-Type" => "application/json" })
      get("/health-including-dependents")
      expect(response).not_to be_successful
    end

    it "returns false if CFE errors out" do
      stub_request(:get, "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/healthcheck")
         .to_return(status: 503)
      get("/health-including-dependents")
      expect(response).not_to be_successful
    end
  end
end
