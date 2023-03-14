require "rails_helper"

RSpec.describe Cfe::SubmitIrregularIncomeService do
  let(:service) { described_class }
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when there is no relevant data" do
      let(:session_data) do
        {
          "student_finance_value" => 0,
          "other_value" => 0,
        }
      end

      it "makes no call" do
        expect(mock_connection).not_to receive(:create_irregular_incomes)
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when the client is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "makes no call" do
        expect(mock_connection).not_to receive(:create_irregular_incomes)
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there is data" do
      let(:session_data) do
        {
          "student_finance_value" => 100,
          "other_value" => 200,
        }
      end

      it "sends it to CFE" do
        expect(mock_connection).to receive(:create_irregular_incomes).with(
          cfe_assessment_id,
          [{ amount: 100, frequency: "annual", income_type: "student_loan" },
           { amount: 200, frequency: "quarterly", income_type: "unspecified_source" }],
        )
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there is data for a controlled check", :controlled_flag do
      let(:session_data) do
        {
          "student_finance_value" => 100,
          "other_value" => 200,
          "level_of_help" => "controlled",
        }
      end

      it "sends it to CFE with an appropriate frequency" do
        expect(mock_connection).to receive(:create_irregular_incomes).with(
          cfe_assessment_id,
          [{ amount: 100, frequency: "annual", income_type: "student_loan" },
           { amount: 200, frequency: "monthly", income_type: "unspecified_source" }],
        )
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
