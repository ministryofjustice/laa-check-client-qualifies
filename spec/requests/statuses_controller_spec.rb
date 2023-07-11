require "rails_helper"

RSpec.describe "status requests" do
  let(:response_json) { JSON.parse(response.body) }

  describe "GET /status" do
    it "is successful and healthy returns true" do
      get("/status")
      expect(response).to be_successful
      expect(response_json).to eq("healthy" => true)
    end

    it "returns false if there is a problem reading from the database" do
      allow(AnalyticsEvent).to receive(:count).and_raise(PG::UndefinedTable)
      get("/status")
      expect(response).not_to be_successful
    end

    it "returns false if there is a problem writing to the cache" do
      allow(Rails.cache).to receive(:write).and_return(false)
      get("/status")
      expect(response).not_to be_successful
    end

    it "returns false if reading from the cache raise an error" do
      allow(Rails.cache).to receive(:read).and_raise(StandardError)
      get("/status")
      expect(response).not_to be_successful
    end

    it "returns false if there is a problem reading from the cache" do
      allow(Rails.cache).to receive(:read).and_return(nil)
      get("/status")
      expect(response).not_to be_successful
    end
  end
end
