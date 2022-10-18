require "rails_helper"
class MockableFaradayClient
  def post(*); end
end

RSpec.describe CfeConnection do
  let(:connection) { described_class.new }
  let(:root_url) { "https://check-financial-eligibility-staging.cloud-platform.service.justice.gov.uk/assessments" }

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

  describe "create_student_loan" do
    let!(:stub) do
      stub_request(:post, "#{root_url}/assessment_id/irregular_incomes").with(
        body: { payments: [{ income_type: :student_loan, frequency: :annual, amount: 50 }] }.to_json,
      ).to_return(status: 200, body: "", headers: {})
    end

    it "calls CFE with amount provided" do
      connection.create_student_loan("assessment_id", 50)
      expect(stub).to have_been_requested
    end

    it "makes no call if amount is null" do
      connection.create_student_loan("assessment_id", nil)
      expect(stub).not_to have_been_requested
    end
  end

  describe "create_regular_payments" do
    let!(:stub) do
      stub_request(:post, "#{root_url}/assessment_id/regular_transactions")
    end

    it "makes no call if no valid data" do
      connection.create_regular_payments("assessment_id", MonthlyIncomeForm.new, nil)
      expect(stub).not_to have_been_requested
    end
  end

  describe "create_properties" do
    let!(:stub) do
      body = { properties: { main_home: { value: 100_000, outstanding_mortgage: 50_000, percentage_owned: 100, shared_with_housing_assoc: false } } }
      stub_request(:post, "#{root_url}/assessment_id/properties").with(body:).to_return(status: 200)
    end

    it "makes a call  without additional properties if only main property is provided" do
      main = { value: 100_000, outstanding_mortgage: 50_000, percentage_owned: 100 }
      connection.create_properties("assessment_id", main, nil)
      expect(stub).to have_been_requested
    end
  end
end
