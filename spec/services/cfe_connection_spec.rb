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

  describe "create_irregular_income" do
    let!(:stub) do
      stub_request(:post, "#{root_url}/assessment_id/irregular_incomes").with(
        body: { payments: [{ income_type: :student_loan, frequency: :annual, amount: 100 }] }.to_json,
      ).to_return(status: 200, body: "", headers: {})
    end

    it "calls CFE with amount provided" do
      payments = [
        {
          "income_type": "student_loan",
          "frequency": "annual",
          "amount": 100,
        },
      ]
      connection.create_irregular_income("assessment_id", payments)
      expect(stub).to have_been_requested
    end
  end

  describe "create_partner" do
    let(:payload) { { test: :payload } }
    let(:assessment_id) { "assessment_id" }
    let!(:stub) do
      stub_request(:post, "#{root_url}/#{assessment_id}/partner_financials").with(
        body: payload.to_json,
      ).to_return(status: 200)
    end

    it "calls CFE with payload provided" do
      connection.create_partner(assessment_id, payload)
      expect(stub).to have_been_requested
    end
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
end
