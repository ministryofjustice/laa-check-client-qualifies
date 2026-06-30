require "rails_helper"

RSpec.describe EmbeddedLandingsController, ccq_mode: :embedded, type: :controller do
  describe "GET #show", :embedded_only do
    let(:host_service_client) { instance_double(HostServiceClient) }
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value" } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
    let(:response_body) { { "return_url" => "http://example.com/return" }.to_json }
    let(:host_service_response) { double(status: 200, body: response_body) }
    let(:first_step) { Steps::Helper.first_step(session_data) }
    let(:step_url_fragment) { Flow::Handler.url_fragment(first_step) }
    let(:logger) { object_double(Rails.logger, warn: nil, info: nil) }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
      allow(HostServiceClient).to receive(:new).and_return(host_service_client)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:init)
      allow(journey_store).to receive(:write)
      allow(FeatureFlags).to receive(:session_flags).and_return({})
      allow(host_service_client).to receive(:load).and_return(host_service_response)
      allow(Rails).to receive(:logger).and_return(logger)
      allow(logger).to receive(:tagged).and_yield
      get :show, params: { resource_id: }
    end

    it "initializes the journey store with feature flags and return URL" do
      expect(journey_store).to have_received(:init).with({
        "feature_flags" => FeatureFlags.session_flags,
        "return_url" => "http://example.com/return",
      })
    end

    it "redirects to the first step of the embedded journey" do
      expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
    end

    it "renders the session expired page if the host service returns 401" do
      allow(host_service_client).to receive(:load).and_return(double(status: 401, body: { error: "expired" }))
      get :show, params: { resource_id: }

      expect(logger).to have_received(:warn).with(
        include("EmbeddedLandingsController received 401 from HostServiceClient: status=401 body_preview={\"error\":\"expired\"}"),
      )
      expect(response).to have_http_status(:unauthorized)
      expect(response).to render_template("errors/session_expired")
    end

    it "renders the access denied page if the host service returns 403" do
      allow(host_service_client).to receive(:load).and_return(double(status: 403, body: nil))
      get :show, params: { resource_id: }

      expect(logger).to have_received(:warn).with(
        include("EmbeddedLandingsController received 403 from HostServiceClient: status=403 body_preview=<nil>"),
      )
      expect(response).to have_http_status(:forbidden)
      expect(response).to render_template("errors/access_denied")
    end

    it "renders the service unavailable page if the host service returns any other error" do
      allow(host_service_client).to receive(:load).and_return(double(status: 500))
      get :show, params: { resource_id: }
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    it "renders the service unavailable page if there is a connection error" do
      allow(host_service_client).to receive(:load).and_raise(HostServiceClient::ConnectionError)
      get :show, params: { resource_id: }
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    context "when host service response body is already parsed" do
      let(:response_body) { { "return_url" => "http://example.com/return" } }

      it "initializes journey data and redirects without JSON parsing" do
        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:init).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "return_url" => "http://example.com/return",
        })
        expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
      end
    end
  end
end
