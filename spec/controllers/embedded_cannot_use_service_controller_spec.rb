RSpec.describe EmbeddedCannotUseServiceController, ccq_mode: :embedded, type: :controller do
  describe "GET #show" do
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value" } }
    let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id, step: "test_step" } } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:write)
      get :show, params: { resource_id: resource_id, step: "test_step" }
    end

    it "assigns @check with session data" do
      expect(assigns(:check)).to be_a(Check)
      expect(assigns(:check).session_data).to eq(session_data)
    end

    it "assigns @previous_step from params" do
      expect(assigns(:previous_step)).to eq("test_step")
    end

    it "assigns @additional_property based on previous_step" do
      expect(assigns(:additional_property)).to be(false)
    end
  end
end
