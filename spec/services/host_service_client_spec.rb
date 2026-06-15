require "rails_helper"

RSpec.describe HostServiceClient do
  subject(:client) { described_class.new }

  let(:host_url) { "http://rcw-service:3000" }
  let(:resource_id) { "abc-123" }
  let(:cookies) { "session=xyz" }

  before do
    stub_const("ENV", ENV.to_h.merge("HOST_SERVICE_URL" => host_url))
  end

  describe "#load" do
    let(:stub) do
      stub_request(:post, "#{host_url}/api/private/load")
        .with(
          body: { resource_id: }.to_json,
          headers: { "Content-Type" => "application/json", "Cookie" => cookies },
        )
        .to_return(status: 200, body: '{"allowed":true}', headers: { "Content-Type" => "application/json" })
    end

    before { stub }

    it "sends a POST to /api/private/load with the resource_id and cookies" do
      client.load(resource_id:, cookies:)
      expect(stub).to have_been_requested
    end

    it "returns the parsed response body" do
      response = client.load(resource_id:, cookies:)
      expect(response.body).to eq({ "allowed" => true })
    end

    it "does not send a Cookie header when cookies are blank" do
      no_cookie_stub = stub_request(:post, "#{host_url}/api/private/load")
        .with { |request| request.body == { resource_id: }.to_json && !request.headers.key?("Cookie") }
        .to_return(status: 200, body: '{"allowed":true}', headers: { "Content-Type" => "application/json" })

      client.load(resource_id:, cookies: nil)
      expect(no_cookie_stub).to have_been_requested
    end
  end

  describe "#save" do
    let(:result) { { "eligible" => true, "amount" => 1000 } }
    let(:stub) do
      stub_request(:post, "#{host_url}/api/private/save")
        .with(
          body: { resource_id:, result: }.to_json,
          headers: { "Content-Type" => "application/json", "Cookie" => cookies },
        )
        .to_return(status: 200, body: '{"saved":true}', headers: { "Content-Type" => "application/json" })
    end

    before { stub }

    it "sends a POST to /api/private/save with the resource_id, result, and cookies" do
      client.save(resource_id:, result:, cookies:) # rubocop:disable Rails/SaveBang
      expect(stub).to have_been_requested
    end

    it "returns the parsed response body" do
      response = client.save(resource_id:, result:, cookies:)
      expect(response.body).to eq({ "saved" => true })
    end
  end

  describe "error handling" do
    before do
      stub_request(:post, "#{host_url}/api/private/load").to_timeout
    end

    it "raises ConnectionError on timeout" do
      expect { client.load(resource_id:, cookies:) }
        .to raise_error(HostServiceClient::ConnectionError)
    end
  end

  describe "connection refused" do
    before do
      stub_request(:post, "#{host_url}/api/private/load")
        .to_raise(Faraday::ConnectionFailed)
    end

    it "raises ConnectionError when the host is unreachable" do
      expect { client.load(resource_id:, cookies:) }
        .to raise_error(HostServiceClient::ConnectionError)
    end
  end
end
