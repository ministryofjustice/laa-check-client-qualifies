require "rails_helper"

RSpec.describe EmbeddedChecksController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:session_data) { { "key" => "value" } }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

  before do
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
    allow(journey_store).to receive(:read).and_return(session_data)
    allow(journey_store).to receive(:write)
    allow(controller).to receive(:track_page_view)
  end

  describe "GET #check_answers", :embedded_only do
    before do
      get :check_answers, params: { resource_id: resource_id }
    end

    it "assigns @check with session data" do
      expect(assigns(:check)).to be_a(Check)
      expect(assigns(:check).session_data).to eq(session_data)
    end

    it "assigns @previous_step from session data" do
      expect(assigns(:previous_step)).to eq(Steps::Helper.last_step(session_data))
    end

    it "assigns @sections from CheckAnswers::SectionListerService" do
      expect(assigns(:sections).map(&:label)).to eq(CheckAnswers::SectionListerService.call(session_data).map(&:label))
    end
  end

  describe "#clear_early_result", :embedded_only do
    it "clears early result from session data cache" do
      controller.instance_variable_set(:@session_data_cache, session_data.merge("early_result" => "some result"))
      controller.send(:clear_early_result)
      expect(controller.instance_variable_get(:@session_data_cache)).not_to have_key("early_result")
    end
  end
end
