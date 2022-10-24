require "rails_helper"

RSpec.describe SubmitIrregularIncomeService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "monthly_incomes" => ["", "student_finance"],
      "friends_or_family" => nil,
      "maintenance" => nil,
      "property_or_lodger" => nil,
      "pension" => nil,
      "student_finance" => "345.0",
      "other" => nil,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    # context "when it is passed valid data with monthly income" do
    #   it "is successful" do
    #     form = Flow::MonthlyIncomeHandler.model(session_data)
    #
    #     payments = [
    #       {
    #         "income_type": "student_loan",
    #         "frequency": "annual",
    #         "amount": 345,
    #       },
    #     ]
    #     expect(mock_connection).to receive(:create_student_loan).with(cfe_estimate_id, { payments: })
    #     service.call(cfe_estimate_id, session_data)
    #   end
    # end

    context "when it is passed invalid data with student loan" do
      let(:root_url) { "https://check-financial-eligibility-staging.cloud-platform.service.justice.gov.uk/assessments" }
      let!(:session_data1) do
        {
          "monthly_incomes" => ["", "student_finance"],
          "friends_or_family" => nil,
          "maintenance" => nil,
          "property_or_lodger" => nil,
          "pension" => nil,
          "student_finance" => nil,
          "other" => nil,
        }
      end
      let!(:stub) do
        stub_request(:post, "#{root_url}/assessment_id/irregular_incomes")
      end

      it "will not submit to CFE without an amount" do
        described_class.call(cfe_estimate_id, session_data1)
        expect(stub).not_to have_been_requested
      end
    end
  end
end
