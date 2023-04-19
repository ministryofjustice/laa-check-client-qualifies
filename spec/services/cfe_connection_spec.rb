require "rails_helper"
class MockableFaradayClient
  def post(*); end
  def get(*); end
end

RSpec.describe CfeConnection do
  let(:connection) { described_class }

  describe "#assess" do
    it "reformats raised errors" do
      faraday_client = instance_double("MockableFaradayClient")
      allow(connection).to receive(:cfe_connection).and_return faraday_client
      allow(faraday_client).to receive(:post).and_return(OpenStruct.new(
                                                           status: 422,
                                                           body: "API error message",
                                                         ))

      expect { connection.assess({}) }.to raise_error(
        "Call to CFE returned status 422 and message:\nAPI error message",
      )
    end
  end

  describe "state_benefit_types" do
    let(:body) { "body" }

    it "calls CFE and returns what it receives" do
      stub_request(:get, %r{state_benefit_type\z}).to_return(body:)
      expect(connection.state_benefit_types).to eq body
    end

    it "returns an empty array if CFE returns an error" do
      faraday_client = instance_double("MockableFaradayClient")
      allow(connection).to receive(:cfe_connection).and_return faraday_client
      allow(faraday_client).to receive(:get).and_raise("Unexpected error")
      expect(connection.state_benefit_types).to eq []
    end
  end

  describe "status" do
    it "returns what CFE provides" do
      stub_request(:get, %r{healthcheck\z})
         .to_return(status: 200, body: { checks: { database: true } }.to_json, headers: { "Content-Type" => "application/json" })
      expect(connection.status).to eq({ database: true })
    end
  end
end
