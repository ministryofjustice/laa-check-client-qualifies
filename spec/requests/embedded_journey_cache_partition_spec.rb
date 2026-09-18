require "rails_helper"

RSpec.describe "embedded journey cache partitioning", ccq_mode: :embedded, type: :request do
  let(:resource_id) { "test_resource_id" }
  let(:cache) { ActiveSupport::Cache::MemoryStore.new }
  let(:host_service_client) { instance_double(HostServiceClient) }

  before do
    allow(ENV).to receive(:fetch).with("HOST_SERVICE_SESSION_COOKIES", "").and_return("service.sid")
    allow(Rails).to receive(:cache).and_return(cache)
    allow(HostServiceClient).to receive(:new).and_return(host_service_client)
    allow(host_service_client).to receive(:load) do |_application_id:, cookies:|
      client_age = cookies.include?("user-a") ? ClientAgeForm::OVER_60 : ClientAgeForm::UNDER_18
      double(status: 200, body: { "data" => { "client_age" => client_age } }.to_json)
    end
    allow(host_service_client).to receive(:save).and_return(double(status: 200))
  end

  it "keeps two users' journeys separate for the same resource" do
    get landing_path(resource_id:), headers: { "Cookie" => "service.sid=user-a" }
    expect(response).to be_redirect

    get landing_path(resource_id:), headers: { "Cookie" => "service.sid=user-b" }
    expect(response).to be_redirect

    expect(cache.read(JourneyDataStore::RedisStore.new(resource_id, "user-a").send(:cache_key))).to include(
      "client_age" => ClientAgeForm::OVER_60,
    )
    expect(cache.read(JourneyDataStore::RedisStore.new(resource_id, "user-b").send(:cache_key))).to include(
      "client_age" => ClientAgeForm::UNDER_18,
    )
  end

  it "deletes only the completing user's journey" do
    first_store = JourneyDataStore::RedisStore.new(resource_id, "user-a")
    second_store = JourneyDataStore::RedisStore.new(resource_id, "user-b")
    first_store.write({ "client_age" => ClientAgeForm::OVER_60 })
    second_store.write({ "client_age" => ClientAgeForm::UNDER_18 })

    post embedded_complete_path(resource_id:), headers: { "Cookie" => "service.sid=user-a" }

    expect(response).to redirect_to("/cases/#{resource_id}/task-list")
    expect { first_store.read }.to raise_error(JourneyDataStore::KeyNotFound)
    expect(second_store.read).to include("client_age" => ClientAgeForm::UNDER_18)
  end
end
