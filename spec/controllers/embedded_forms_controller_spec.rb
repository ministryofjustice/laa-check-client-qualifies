require "rails_helper"

RSpec.describe EmbeddedFormsController, ccq_mode: :embedded, type: :controller do
  let(:resource_id) { "test_resource_id" }
  let(:session_data) { { "key" => "value" } }
  let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
  let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

  before do
    allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
    allow(journey_store).to receive(:read).and_return(session_data)
    allow(journey_store).to receive(:write)
  end

  describe "GET #show", :embedded_only do
    before do
      get :show, params: { resource_id: resource_id, step_url_fragment: "client-age-group" }
    end

    it "assigns @check with session data" do
      expect(assigns(:check)).to be_a(Check)
      expect(assigns(:check).session_data).to eq(session_data)
    end

    it "assigns @previous_step from session data" do
      expect(assigns(:previous_step)).to eq(Steps::Helper.previous_step_for(session_data, :client_age))
    end
  end

  describe "POST #update", :embedded_only do
    let(:valid_params) do
      {
        resource_id: resource_id,
        step_url_fragment: "client-age-group",
        client_age_form: {
          client_age: ClientAgeForm::OVER_60,
        },
      }
    end

    before do
      allow(controller).to receive(:track_choices)
      allow(controller).to receive(:track_validation_error)
    end

    context "with valid parameters" do
      it "updates the session data and redirects to the next step" do
        post :update, params: valid_params
        expect(session_data).to include("client_age" => ClientAgeForm::OVER_60)
        expect(response).to have_http_status(:redirect)
        expect(response.location).to include("/#{resource_id}/")
        expect(response.location).to end_with("/what-level-help")
      end

      it "redirects to the cannot use service page if the next step is a cannot use service step" do
        allow(Steps::Helper).to receive(:cannot_use_service?).and_return(true)
        post :update, params: valid_params
        expect(response).to have_http_status(:redirect)
        expect(response.location).to include("/#{resource_id}/")
        expect(response.location).to include("/cannot-use-service/")
      end

      it "redirects to the check answers page if there is no next step" do
        allow(Steps::Helper).to receive(:next_step_for).and_return(nil)
        post :update, params: valid_params
        expect(response).to have_http_status(:redirect)
        expect(response.location).to include("/#{resource_id}/")
        expect(response.location).to end_with("/check-answers")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { valid_params.deep_merge(client_age_form: { client_age: "" }) }

      it "does not update the session data and re-renders the form with errors" do
        post :update, params: invalid_params
        expect(session_data).not_to include("client_age")
        expect(response).to render_template("question_flow/client_age")
      end
    end
  end
end
