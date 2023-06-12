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

    it "adds a user agent string" do
      stub = stub_request(:post, %r{assessments\z}).with do |request|
        expect(request.headers["User-Agent"]).to match(/ccq\/.* \(.*\)/)
      end
      connection.assess({})
      expect(stub).to have_been_requested
    end

    context "when there is a version file" do
      before do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with(Rails.root.join("VERSION")).and_return(true)
        allow(File).to receive(:read).and_call_original
        allow(File).to receive(:read).with(Rails.root.join("VERSION")).and_return("someversion")
      end

      it "adds a user agent string using a file if there is one" do
        stub = stub_request(:post, %r{assessments\z}).with do |request|
          expect(request.headers["User-Agent"]).to match(/ccq\/someversion \(.*\)/)
        end
        connection.assess({})
        expect(stub).to have_been_requested
      end
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
