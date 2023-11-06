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

  describe "GET /health" do
    it "is successful and healthy returns true" do
      get("/health")
      expect(response).to be_successful
      expect(response_json).to eq("healthy" => true)
    end

    it "returns false if there is a problem reading from the database" do
      allow(ActiveRecord::Base).to receive(:connection).and_raise(PG::UndefinedTable)
      get("/health")
      expect(response).not_to be_successful
    end

    it "returns false if there is a problem writing to the cache" do
      allow(Rails.cache).to receive(:write).and_return(false)
      get("/health")
      expect(response).not_to be_successful
    end

    it "returns false if reading from the cache raise an error" do
      allow(Rails.cache).to receive(:read).and_raise(StandardError)
      get("/health")
      expect(response).not_to be_successful
    end

    it "returns false if there is a problem reading from the cache" do
      allow(Rails.cache).to receive(:read).and_return(nil)
      get("/health")
      expect(response).not_to be_successful
    end

    it "responds to an inactive connection" do
      allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false, true)
      expect(ActiveRecord::Base.connection).to receive(:reconnect!)
      get("/health")
      expect(response).to be_successful
    end
  end
end
