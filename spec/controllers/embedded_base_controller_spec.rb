require "rails_helper"

RSpec.describe EmbeddedBaseController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

  before do
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
  end

  describe "#session_data", :embedded_only do
    context "when session data is present" do
      let(:session_data) { { "key" => "value" } }

      before do
        allow(journey_store).to receive(:read).and_return(session_data)
      end

      it "returns the session data" do
        expect(controller.send(:session_data)).to eq(session_data)
      end
    end

    context "when session data is missing" do
      before do
        allow(journey_store).to receive(:read).and_raise(JourneyDataStore::KeyNotFound)
      end

      it "raises MissingSessionError" do
        expect { controller.send(:session_data) }.to raise_error(ApplicationController::MissingSessionError)
      end
    end
  end

  describe "#persist_journey_data", :embedded_only do
    let(:session_data_cache) { { "key" => "value" } }

    before do
      controller.instance_variable_set(:@session_data_cache, session_data_cache)
      allow(journey_store).to receive(:write)
      controller.send(:persist_journey_data)
    end

    it "writes the session data cache to the journey store" do
      expect(journey_store).to have_received(:write).with(session_data_cache)
    end
  end

  describe "#tag_logs_with_resource_id", :embedded_only do
    it "tags logs with the resource_id" do
      expect(Rails.logger).to receive(:tagged).with("resource_id:#{resource_id}", any_args)
      controller.send(:tag_logs_with_resource_id) {}
    end
  end

  describe "#journey_store", :embedded_only do
    it "initializes a JourneyDataStore::RedisStore with the resource_id" do
      expect(JourneyDataStore::RedisStore).to receive(:new).with(resource_id)
      controller.send(:journey_store)
    end
  end

  describe "#assessment_code", :embedded_only do
    it "returns the resource_id as the assessment code" do
      expect(controller.send(:assessment_code)).to eq(resource_id)
    end
  end

  describe "rescue_from Cfe::InvalidSessionError", :embedded_only do
    it "redirects to the embedded landing page" do
      expect(controller).to receive(:redirect_to).with(:landing)
      controller.send(:rescue_with_handler, Cfe::InvalidSessionError.new(ApplicantForm.new))
    end
  end

  describe "rescue_from ApplicationController::MissingSessionError", :embedded_only do
    it "redirects to the embedded landing page" do
      expect(controller).to receive(:redirect_to).with(:landing)
      controller.send(:rescue_with_handler, ApplicationController::MissingSessionError.new(ApplicantForm.new))
    end
  end
end
