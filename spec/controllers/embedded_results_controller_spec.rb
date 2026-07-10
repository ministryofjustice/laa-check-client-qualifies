require "rails_helper"

RSpec.describe EmbeddedResultsController, ccq_mode: :embedded, type: :controller do
  describe "GET #show", :embedded_only do
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value", "api_response" => {} } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:write)
      get :show, params: { resource_id: }
    end

    it "loads the session data from the journey store" do
      expect(journey_store).to have_received(:read)
    end

    it "renders the results show template" do
      expect(response).to render_template("results/show")
    end

    it "assigns the model with the session data" do
      expect(assigns(:model)).to be_a(CalculationResult)
      expect(assigns(:model).level_of_help).to eq("certificated")
    end
  end

  describe "POST #create", :embedded_only do
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value" } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
    let(:api_response) { { "result" => "some_result" } }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:write)
      allow(CfeService).to receive(:call).and_return(api_response)
      post :create, params: { resource_id: }
    end

    it "calls the CfeService with the session data and relevant steps" do
      expect(CfeService).to have_received(:call).with(session_data, Steps::Helper.relevant_steps(session_data))
    end

    it "stores the API response in the session data" do
      expect(journey_store).to have_received(:write).with(hash_including("api_response" => api_response))
    end

    it "redirects to the result path" do
      expect(response).to redirect_to(result_path(resource_id:))
    end
  end

  describe "POST #early_result_redirect", :embedded_only do
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value" } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
    let(:api_response) { { "result" => "some_result" } }
    let(:previous_step) { :some_step }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:write)
      allow(CfeService).to receive(:call).and_return(api_response)
      post :early_result_redirect, params: { resource_id:, step: previous_step }
    end

    it "calls the CfeService with the session data and completed steps for the previous step" do
      expect(CfeService).to have_received(:call).with(session_data, Steps::Helper.completed_steps_for(session_data, previous_step))
    end

    it "stores the API response in the session data" do
      expect(journey_store).to have_received(:write).with(hash_including("api_response" => api_response))
    end

    it "redirects to the result path" do
      expect(response).to redirect_to(result_path(resource_id:))
    end
  end

  describe "POST #complete", :embedded_only do
    let(:resource_id) { "test_resource_id" }
    let(:session_data) { { "key" => "value", "api_response" => { "result" => "some_result" }, "return_url" => return_url } }
    let(:journey_store) { instance_double(JourneyDataStore::RedisStore) }
    let(:return_url) { "http://example.com/return" }
    let(:host_service_client) { instance_double(HostServiceClient) }
    let(:host_service_response) { double(status: 200) }

    before do
      allow(JourneyDataStore::RedisStore).to receive(:new).with(resource_id).and_return(journey_store)
      allow(journey_store).to receive(:read).and_return(session_data)
      allow(journey_store).to receive(:write)
      allow(journey_store).to receive(:delete)
      allow(HostServiceClient).to receive(:new).and_return(host_service_client)
      allow(host_service_client).to receive(:save).and_return(host_service_response)
      post :complete, params: { resource_id: }
    end

    it "calls the HostServiceClient to save the result" do
      expect(host_service_client).to have_received(:save).with(
        resource_id:,
        result: session_data["api_response"],
        cookies: anything,
      )
    end

    it "deletes the journey store after saving the result" do
      expect(journey_store).to have_received(:delete)
    end

    it "redirects to the return URL" do
      expect(response).to redirect_to(return_url)
    end

    it "raises when return_url is missing from journey data" do
      allow(journey_store).to receive(:read).and_return(session_data.merge("return_url" => nil))

      expect { post :complete, params: { resource_id: } }.to raise_error("Missing return_url in journey data")
    end

    it "redirects when the return URL host is allowed" do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ALLOWED_RETURN_HOSTS", "").and_return("example.com")

      post :complete, params: { resource_id: }

      expect(response).to redirect_to(return_url)
      expect(journey_store).to have_received(:delete).at_least(:once)
    end

    it "renders the access denied page if the return URL host is not allowed" do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ALLOWED_RETURN_HOSTS", "").and_return("notallowed.com")
      post :complete, params: { resource_id: }
      expect(response).to have_http_status(:forbidden)
      expect(response).to render_template("errors/access_denied")
    end

    it "renders the session expired page if the host service returns 401" do
      allow(host_service_client).to receive(:save).and_return(double(status: 401))
      post :complete, params: { resource_id: }
      expect(response).to have_http_status(:unauthorized)
      expect(response).to render_template("errors/session_expired")
    end

    it "redirects to host reauthentication when the host service returns 302" do
      allow(host_service_client).to receive(:save).and_return(
        double(status: 302, headers: { "location" => "https://test.host/auth/sign-in?foo=bar" }),
      )
      request.env["HTTP_REFERER"] = "http://test.host/cases/#{resource_id}/eligibility/check-result"

      post :complete, params: { resource_id: }

      redirect_uri = URI.parse(response.location)
      query_params = Rack::Utils.parse_nested_query(redirect_uri.query)

      expect(redirect_uri.to_s).to start_with("https://test.host/auth/sign-in")
      expect(query_params["foo"]).to eq("bar")
      expect(query_params["returnTo"]).to eq("/cases/#{resource_id}/eligibility/complete")
    end

    it "uses the current request path even when referer is missing" do
      allow(host_service_client).to receive(:save).and_return(
        double(status: 302, headers: { "location" => "https://test.host/auth/sign-in" }),
      )
      request.env.delete("HTTP_REFERER")

      post :complete, params: { resource_id: }

      redirect_uri = URI.parse(response.location)
      query_params = Rack::Utils.parse_nested_query(redirect_uri.query)

      expect(query_params["returnTo"]).to eq("/cases/#{resource_id}/eligibility/complete")
    end

    it "renders service unavailable when host reauthentication redirect location host is unexpected" do
      allow(host_service_client).to receive(:save).and_return(
        double(status: 302, headers: { "location" => "https://login.example.com/auth/sign-in" }),
      )

      post :complete, params: { resource_id: }

      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    it "renders service unavailable when host reauthentication redirect location is missing" do
      allow(host_service_client).to receive(:save).and_return(double(status: 302, headers: {}))

      post :complete, params: { resource_id: }

      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    it "renders the access denied page if the host service returns 403" do
      allow(host_service_client).to receive(:save).and_return(double(status: 403))
      post :complete, params: { resource_id: }
      expect(response).to have_http_status(:forbidden)
      expect(response).to render_template("errors/access_denied")
    end

    it "renders the service unavailable page if the host service returns any other error" do
      allow(host_service_client).to receive(:save).and_return(double(status: 500))
      post :complete, params: { resource_id: }
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end

    it "renders the service unavailable page if there is a connection error" do
      allow(host_service_client).to receive(:save).and_raise(HostServiceClient::ConnectionError)
      post :complete, params: { resource_id: }
      expect(response).to have_http_status(:service_unavailable)
      expect(response).to render_template("errors/service_unavailable")
    end
  end

  describe "private helpers", :embedded_only do
    before do
      allow(EmbeddedBaseController).to receive(:local_prefixes).and_return(%w[embedded_base])
    end

    it "described local_prefixes are prepended to superclass prefixes" do
      expect(described_class.local_prefixes).to eq(%w[results embedded_base])
    end
  end
end
