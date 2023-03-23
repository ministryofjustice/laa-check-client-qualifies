require "rails_helper"
class MockableFaradayClient
  def post(*); end
  def get(*); end
end

RSpec.describe CfeConnection do
  let(:connection) { described_class.new }
  let(:host) { "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk" }
  let(:root_url) { "#{host}/assessments" }

  it "reformats raised errors" do
    faraday_client = instance_double("MockableFaradayClient")
    allow(connection).to receive(:cfe_connection).and_return faraday_client
    allow(faraday_client).to receive(:post).and_return(OpenStruct.new(
                                                         status: 422,
                                                         body: "API error message",
                                                       ))

    expect { connection.create_dependants("id", 1) }.to raise_error(
      "Call to CFE url /assessments/id/dependants returned status 422 and message:\nAPI error message",
    )
  end

  shared_examples "a standard CFE wrapper" do |endpoint, explicit_key|
    let(:assessment_id) { "assessment_id" }
    let(:payload) { { foo: :bar } }

    it "calls CFE with payload provided" do
      key = explicit_key || endpoint
      method_name = "create_#{endpoint}"
      stub = stub_request(:post, "#{root_url}/#{assessment_id}/#{endpoint}").with(body: { key => payload }.to_json)
      connection.send(method_name, assessment_id, payload)
      expect(stub).to have_been_requested
    end
  end

  shared_examples "a multi-key CFE wrapper" do |endpoint|
    let(:assessment_id) { "assessment_id" }
    let(:payload) { { foo: :bar } }

    it "calls CFE with payload provided" do
      method_name = "create_#{endpoint}"
      stub = stub_request(:post, "#{root_url}/#{assessment_id}/#{endpoint}").with(body: payload.to_json)
      connection.send(method_name, assessment_id, payload)
      expect(stub).to have_been_requested
    end
  end

  describe "create_proceeding_types" do
    it_behaves_like "a standard CFE wrapper", :proceeding_types
  end

  describe "create_applicant" do
    it_behaves_like "a standard CFE wrapper", :applicant
  end

  describe "create_dependants" do
    it_behaves_like "a standard CFE wrapper", :dependants
  end

  describe "create_irregular_incomes" do
    it_behaves_like "a standard CFE wrapper", :irregular_incomes, :payments
  end

  describe "create_employments" do
    it_behaves_like "a standard CFE wrapper", :employments, :employment_income
  end

  describe "create_state_benefits" do
    it_behaves_like "a standard CFE wrapper", :state_benefits
  end

  describe "create_properties" do
    it_behaves_like "a standard CFE wrapper", :properties
  end

  describe "create_partner_financials" do
    it_behaves_like "a multi-key CFE wrapper", :partner_financials
  end

  describe "create_capitals" do
    it_behaves_like "a multi-key CFE wrapper", :capitals
  end

  describe "state_benefit_types" do
    let(:body) { "body" }

    it "calls CFE and returns what it receives" do
      stub_request(:get, "#{host}/state_benefit_type").to_return(body:)
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
      stub_request(:get, "#{host}/healthcheck")
         .to_return(status: 200, body: { checks: { database: true } }.to_json, headers: { "Content-Type" => "application/json" })
      expect(connection.status).to eq({ database: true })
    end
  end

  describe "api_result" do
    let(:assessment_id) { :assessment_id }
    let(:payload) { { "foo" => "bar" } }

    it "returns what CFE provides wrapped in a calculation result" do
      stub_request(:get, "#{root_url}/#{assessment_id}")
        .to_return(status: 200, body: payload.to_json, headers: { "Content-Type" => "application/json" })
      result = connection.api_result(assessment_id)
      expect(result).to eq(payload)
    end
  end

  describe "create_assessment_id" do
    let(:assessment_id) { "assessment_id" }
    let(:output_payload) { { assessment_id: } }
    let(:input_payload) { { foo: "bar" } }

    it "returns what CFE provides" do
      stub_request(:post, root_url)
        .with(body: input_payload.to_json)
        .to_return(status: 200, body: output_payload.to_json, headers: { "Content-Type" => "application/json" })
      expect(connection.create_assessment_id(input_payload)).to eq(assessment_id)
    end
  end
end
