require "rails_helper"

RSpec.describe HostServiceClient do
  subject(:client) { described_class.new }

  let(:host_url) { "http://host-service:3000" }
  let(:application_id) { "abc-123" }
  let(:eligibility_path) { "/api/applications/#{application_id}/eligibility" }
  let(:cookies) { "session=xyz" }
  let(:logger) { instance_double(Logger, info: nil) }

  before do
    stub_const("ENV", ENV.to_h.merge("HOST_SERVICE_URL" => host_url))
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe "#load" do
    let(:response_body) { '{"allowed":true}' }

    let(:stub) do
      stub_request(:get, "#{host_url}#{eligibility_path}")
        .with(headers: { "Cookie" => cookies })
        .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })
    end

    before { stub }

    it "sends a GET to the eligibility endpoint with cookies" do
      client.load(application_id:, cookies:)
      expect(stub).to have_been_requested
    end

    it "returns the parsed response body" do
      response = client.load(application_id:, cookies:)
      expect(response.body).to eq({ "allowed" => true })
    end

    context "when the response contains sensitive data" do
      let(:response_body) { { error: "SYNTHETIC-LOAD-DO-NOT-LOG" }.to_json }

      it "returns the response without logging it" do
        response = client.load(application_id:, cookies:)

        expect(response.status).to eq(200)
        expect(response.body).to eq(JSON.parse(response_body))
        expect(logger).not_to have_received(:info)
      end
    end

    it "does not send a Cookie header when cookies are blank" do
      no_cookie_stub = stub_request(:get, "#{host_url}#{eligibility_path}")
        .with { |request| !request.headers.key?("Cookie") }
        .to_return(status: 200, body: '{"allowed":true}', headers: { "Content-Type" => "application/json" })

      client.load(application_id:, cookies: nil)
      expect(no_cookie_stub).to have_been_requested
    end
  end

  describe "#save" do
    let(:eligibility_assessment) { { "eligible" => true, "amount" => 1000 } }
    let(:response_body) { '{"saved":true}' }
    let(:stub) do
      stub_request(:put, "#{host_url}#{eligibility_path}")
        .with(
          body: { eligibility_assessment: }.to_json,
          headers: { "Content-Type" => "application/json", "Cookie" => cookies },
        )
        .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })
    end

    before { stub }

    it "sends a PUT to the eligibility endpoint with the eligibility_assessment and cookies" do
      client.save(application_id:, eligibility_assessment:, cookies:) # rubocop:disable Rails/SaveBang
      expect(stub).to have_been_requested
    end

    it "returns the parsed response body" do
      response = client.save(application_id:, eligibility_assessment:, cookies:)
      expect(response.body).to eq({ "saved" => true })
    end

    context "when the response contains sensitive data" do
      let(:response_body) { { error: "SYNTHETIC-SAVE-DO-NOT-LOG" }.to_json }

      it "returns the response without logging it" do
        response = client.save(application_id:, eligibility_assessment:, cookies:)

        expect(response.status).to eq(200)
        expect(response.body).to eq(JSON.parse(response_body))
        expect(logger).not_to have_received(:info)
      end
    end
  end

  describe "error handling" do
    before do
      stub_request(:get, "#{host_url}#{eligibility_path}")
        .to_timeout
    end

    it "raises ConnectionError on timeout" do
      expect { client.load(application_id:, cookies:) }
        .to raise_error(HostServiceClient::ConnectionError)
    end
  end

  describe "connection refused" do
    before do
      stub_request(:get, "#{host_url}#{eligibility_path}")
        .to_raise(Faraday::ConnectionFailed)
    end

    it "raises ConnectionError when the host is unreachable" do
      expect { client.load(application_id:, cookies:) }
        .to raise_error(HostServiceClient::ConnectionError)
    end
  end

  describe "save error handling" do
    let(:eligibility_assessment) { { "eligible" => true } }

    it "raises ConnectionError on timeout" do
      stub_request(:put, "#{host_url}#{eligibility_path}")
        .with(body: { eligibility_assessment: }.to_json)
        .to_timeout

      expect { client.save(application_id:, eligibility_assessment:, cookies:) }
        .to raise_error(HostServiceClient::ConnectionError)
    end

    it "raises ConnectionError when the host is unreachable" do
      stub_request(:put, "#{host_url}#{eligibility_path}")
        .with(body: { eligibility_assessment: }.to_json)
        .to_raise(Faraday::ConnectionFailed)

      expect { client.save(application_id:, eligibility_assessment:, cookies:) }
        .to raise_error(HostServiceClient::ConnectionError)
    end
  end
end
