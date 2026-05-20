require "rails_helper"

RSpec.describe EmbeddedChangeAnswersController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:session_data) { { "key" => "value" } }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

  before do
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
    allow(journey_store).to receive(:read) { session_data.dup }
    allow(journey_store).to receive(:write)
    allow(controller).to receive(:track_page_view)
    allow(Flow::Handler).to receive(:form_from_session).and_return(double("form"))
  end

  describe "GET #show", :embedded_only do
    before do
      get :show, params: { resource_id: resource_id, step_url_fragment: "client-age-group" }
    end

    it "assigns @check with session data" do
      expect(assigns(:check)).to be_a(Check)
      expect(assigns(:check).session_data).to include(session_data)
    end

    it "assigns @previous_step from session data" do
      expect(assigns(:previous_step)).to eq(Steps::Helper.last_step(session_data))
    end
  end
end
