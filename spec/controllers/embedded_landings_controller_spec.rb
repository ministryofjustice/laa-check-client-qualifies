require "rails_helper"

RSpec.describe EmbeddedLandingsController, ccq_mode: :embedded, type: :controller do
  describe "GET #show", :embedded_only do
    let(:host_service_client) { instance_double(HostServiceClient) }
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value" } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
    let(:response_body) { {}.to_json }
    let(:host_service_response) { double(status: 200, body: response_body) }
    let(:first_step) { Steps::Helper.first_step(session_data) }
    let(:step_url_fragment) { Flow::Handler.url_fragment(first_step) }
    let(:logger) { object_double(Rails.logger, warn: nil, info: nil, error: nil) }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id, anything).and_return(journey_store)
      allow(HostServiceClient).to receive(:new).and_return(host_service_client)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:write)
      allow(FeatureFlags).to receive(:session_flags).and_return({})
      allow(host_service_client).to receive(:load).and_return(host_service_response)
      allow(Rails).to receive(:logger).and_return(logger)
      allow(logger).to receive(:tagged).and_yield
      get :show, params: { resource_id: }
    end

    it "calls the HostServiceClient with the application_id and cookies" do
      expect(host_service_client).to have_received(:load).with(
        application_id: resource_id,
        cookies: anything,
      )
    end

    it "writes the journey store with feature flags and pre-filled embedded values" do
      expect(journey_store).to have_received(:write).with({
        "feature_flags" => FeatureFlags.session_flags,
        "level_of_help" => "controlled",
        "immigration_or_asylum" => false,
      })
    end

    it "redirects to the first step of the embedded journey" do
      expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
    end

    it "logs the hydrated fresh journey once" do
      expect(logger).to have_received(:info).once.with(hash_including(
                                                         message: "Embedded journey started", context: hash_including(event: "embedded.journey.started", caseId: resource_id),
                                                       ))
    end

    it "renders the session expired page without logging the host response body" do
      sentinel = "SYNTHETIC-RESPONSE-DO-NOT-LOG"
      allow(host_service_client).to receive(:load).and_return(
        double(status: 401, body: { error: sentinel }),
      )

      get :show, params: { resource_id: }

      expect(journey_store).to have_received(:write).exactly(2).times
      expect(logger).to have_received(:warn).once.with(hash_including(
                                                         context: hash_including(event: "security.authentication.failed", statusCode: 401),
                                                       ))
      expect(logger).not_to have_received(:warn).with(satisfy { |entry| entry.to_json.include?(sentinel) })
      expect(response).to have_http_status(:unauthorized)
      expect(response).to render_template("errors/session_expired")
    end

    it "renders the session expired page when cache hydration has no session cookie" do
      allow(journey_store).to receive(:write).and_raise(JourneyDataStore::KeyNotFound)

      get :show, params: { resource_id: }

      expect(response).to have_http_status(:unauthorized)
      expect(response).to render_template("errors/session_expired")
    end

    it "redirects to host reauthentication when the host service returns 302" do
      allow(host_service_client).to receive(:load).and_return(
        double(status: 302, body: nil, headers: { "location" => "https://test.host/auth/sign-in?prompt=login" }),
      )

      get :show, params: { resource_id: }

      redirect_uri = URI.parse(response.location)
      query_params = Rack::Utils.parse_nested_query(redirect_uri.query)

      expect(redirect_uri.to_s).to start_with("https://test.host/auth/sign-in")
      expect(query_params["prompt"]).to eq("login")
      expect(query_params["returnTo"]).to eq("/cases/#{resource_id}/eligibility")
    end

    it "redirects to host reauthentication when Location header is capitalized" do
      allow(host_service_client).to receive(:load).and_return(
        double(status: 302, body: nil, headers: { "Location" => "https://test.host/auth/sign-in?prompt=login" }),
      )

      get :show, params: { resource_id: }

      redirect_uri = URI.parse(response.location)
      query_params = Rack::Utils.parse_nested_query(redirect_uri.query)

      expect(redirect_uri.to_s).to start_with("https://test.host/auth/sign-in")
      expect(query_params["prompt"]).to eq("login")
      expect(query_params["returnTo"]).to eq("/cases/#{resource_id}/eligibility")
    end

    it "renders service unavailable when host reauthentication redirect location is missing" do
      allow(host_service_client).to receive(:load).and_return(double(status: 302, body: nil, headers: {}))

      get :show, params: { resource_id: }

      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.redirect_rejected", reason: "missing_location"),
                                                        ))
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    it "renders service unavailable when host reauthentication redirect location is invalid" do
      allow(host_service_client).to receive(:load).and_return(
        double(status: 302, body: nil, headers: { "location" => "invalid://[]" }),
      )

      get :show, params: { resource_id: }

      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.redirect_rejected", reason: "invalid_location"),
                                                        ))
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    it "renders the access denied page without logging the host response body" do
      sentinel = "SYNTHETIC-FORBIDDEN-DO-NOT-LOG"
      allow(host_service_client).to receive(:load).and_return(double(status: 403, body: sentinel))
      get :show, params: { resource_id: }

      expect(logger).to have_received(:warn).once.with(hash_including(
                                                         context: hash_including(event: "security.authorisation.denied", statusCode: 403),
                                                       ))
      expect(logger).not_to have_received(:warn).with(satisfy { |entry| entry.to_json.include?(sentinel) })
      expect(response).to have_http_status(:forbidden)
      expect(response).to render_template("errors/access_denied")
    end

    it "renders the service unavailable page if the host service returns any other error" do
      allow(host_service_client).to receive(:load).and_return(double(status: 500))
      get :show, params: { resource_id: }
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.request.failed", statusCode: 500, reason: "unexpected_status"),
                                                        ))
    end

    it "renders the service unavailable page if there is a connection error" do
      allow(host_service_client).to receive(:load).and_raise(HostServiceClient::ConnectionError)
      get :show, params: { resource_id: }
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
      expect(logger).to have_received(:error).once.with(hash_including(
                                                          context: hash_including(event: "embedded.host.request.failed", reason: "transport_error"),
                                                        ))
    end

    it "re-raises unexpected errors from host service" do
      allow(host_service_client).to receive(:load).and_raise(StandardError, "boom")

      expect { get :show, params: { resource_id: } }.to raise_error(StandardError, "boom")
    end

    context "when host service response body is already parsed" do
      let(:response_body) { {} }

      it "initializes journey data and redirects without JSON parsing" do
        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
        expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
      end
    end

    context "when the host service response includes a previously completed eligibility assessment" do
      let(:response_body) do
        {
          "data" => {
            "level_of_help" => "controlled_legal_representation",
            "client_age" => ClientAgeForm::STANDARD,
          },
          "result" => { "indication" => true },
        }.to_json
      end

      it "seeds the journey store with the resumed assessment data" do
        expect(journey_store).to have_received(:write).at_least(:once).with({
          "level_of_help" => "controlled_legal_representation",
          "client_age" => ClientAgeForm::STANDARD,
          "api_response" => { "indication" => true },
          "feature_flags" => FeatureFlags.session_flags,
        })
      end

      it "redirects to the results page" do
        expect(response).to redirect_to(result_path(resource_id:))
      end

      it "logs the hydrated resumed journey once" do
        expect(logger).to have_received(:info).once.with(hash_including(
                                                           message: "Embedded journey resumed", context: hash_including(event: "embedded.journey.resumed"),
                                                         ))
      end

      context "when destination param requests check-answers" do
        it "redirects to the check-answers page" do
          get :show, params: { resource_id:, destination: "check-answers" }

          expect(response).to redirect_to(check_answers_path(resource_id:))
        end
      end

      context "when destination param requests check-result" do
        it "redirects to the results page" do
          get :show, params: { resource_id:, destination: "check-result" }

          expect(response).to redirect_to(result_path(resource_id:))
        end
      end

      context "when destination param is unrecognised" do
        it "falls back to the results page" do
          get :show, params: { resource_id:, destination: "not-a-real-destination" }

          expect(response).to redirect_to(result_path(resource_id:))
        end
      end
    end

    context "when the host service response includes a fresh client age" do
      let(:response_body) do
        {
          "data" => { "client_age" => ClientAgeForm::STANDARD },
        }.to_json
      end

      it "hydrates the age alongside the embedded defaults" do
        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
          "client_age" => ClientAgeForm::STANDARD,
        })
      end

      it "continues as a fresh journey" do
        expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
      end
    end

    context "when the eligibility assessment is malformed or partial" do
      it "falls back to a fresh journey when result is missing" do
        allow(host_service_client).to receive(:load).and_return(
          double(status: 200, body: {
            "data" => { "level_of_help" => "controlled_legal_representation" },
          }.to_json),
        )

        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
        expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
      end

      it "falls back to a fresh journey when data is not an object" do
        allow(host_service_client).to receive(:load).and_return(
          double(status: 200, body: {
            "data" => "not-an-object",
            "result" => { "indication" => true },
          }.to_json),
        )

        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
        expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
      end

      it "falls back to a fresh journey when result is not an object" do
        allow(host_service_client).to receive(:load).and_return(
          double(status: 200, body: {
            "data" => { "level_of_help" => "controlled_legal_representation" },
            "result" => "not-an-object",
          }.to_json),
        )

        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
        expect(response).to redirect_to(step_path(resource_id:, step_url_fragment:))
      end

      it "does not hydrate a missing client age" do
        allow(host_service_client).to receive(:load).and_return(
          double(status: 200, body: { "data" => {} }.to_json),
        )

        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
      end

      it "does not hydrate an invalid client age" do
        allow(host_service_client).to receive(:load).and_return(
          double(status: 200, body: { "data" => { "client_age" => "invalid" } }.to_json),
        )

        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
      end

      it "does not hydrate client age when data is not an object" do
        allow(host_service_client).to receive(:load).and_return(
          double(status: 200, body: { "data" => "not-an-object" }.to_json),
        )

        get :show, params: { resource_id: }

        expect(journey_store).to have_received(:write).at_least(:once).with({
          "feature_flags" => FeatureFlags.session_flags,
          "level_of_help" => "controlled",
          "immigration_or_asylum" => false,
        })
      end
    end
  end
end
