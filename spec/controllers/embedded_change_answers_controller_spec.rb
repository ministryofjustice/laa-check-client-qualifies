require "rails_helper"

RSpec.describe EmbeddedChangeAnswersController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:session_data) { { "key" => "value", pending: nil } }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
  let(:form) { instance_double(ClientAgeForm) }

  before do
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
    allow(journey_store).to receive(:read) { session_data.dup }
    allow(journey_store).to receive(:write)
    allow(controller).to receive(:track_page_view)
    allow(Flow::Handler).to receive(:form_from_session).and_return(form)
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

  describe "GET #show for a step that is skipped in embedded mode", :embedded_only do
    it "redirects to check answers without rendering the form" do
      get :show, params: { resource_id: resource_id, step_url_fragment: "what-level-help" }

      expect(response).to have_http_status(:redirect)
      expect(response.location).to end_with("/check-answers")
    end
  end

  describe "POST #update", :embedded_only do
    let(:step_url_fragment) { "client-age-group" }
    let(:model) { instance_double(ClientAgeForm, valid?: false) }

    before do
      allow(Flow::Handler).to receive(:model_from_params).and_return(model)
      allow(controller).to receive(:track_validation_error)
    end

    context "when the step is not skipped in embedded mode" do
      it "delegates to the shared update behaviour" do
        post :update, params: { resource_id: resource_id, step_url_fragment: step_url_fragment }
        expect(response).to render_template("question_flow/client_age")
      end
    end

    context "when the step is skipped in embedded mode" do
      let(:step_url_fragment) { "what-level-help" }

      it "redirects to check answers without processing the submitted form" do
        post :update, params: { resource_id: resource_id, step_url_fragment: step_url_fragment }

        expect(Flow::Handler).not_to have_received(:model_from_params)
        expect(response.location).to end_with("/check-answers")
      end
    end
  end

  describe "#session_data", :embedded_only do
    it "returns the session data from the journey store" do
      expect(controller.send(:session_data)).to eq(session_data)
    end

    it "raises and rescues JourneyDataStore::KeyNotFound if the key is not found in the journey store" do
      controller.instance_variable_set(:@session_data_cache, nil) # Clear the cache
      allow(journey_store).to receive(:read).and_raise(JourneyDataStore::KeyNotFound)
      expect { controller.send(:session_data) }.to raise_error(ApplicationController::MissingSessionError)
    end
  end

  describe "#save_and_redirect_to_check_answers", :embedded_only do
    let(:anchor) { "test-anchor" }
    let(:expected_path) { "/embedded/#{resource_id}/check-answers" }

    before do
      allow(controller).to receive(:anchor).and_return(anchor)
      allow(controller).to receive(:check_answers_path).with(resource_id: resource_id, anchor:).and_return(expected_path)
      allow(controller).to receive(:redirect_to)
      controller.params[:resource_id] = resource_id
    end

    it "promotes the pending session data to the main session data cache" do
      controller.save_and_redirect_to_check_answers
      expect(controller.instance_variable_get(:@session_data_cache)).to eq(session_data)
    end

    it "redirects to the check answers page with the correct anchor" do
      expect(controller).to receive(:redirect_to).with(expected_path)
      controller.save_and_redirect_to_check_answers
    end
  end
end
