require "rails_helper"

RSpec.describe Cfe::IrregularIncomePayloadService do
  let(:service) { described_class }
  let(:payload) { {} }

  describe ".call" do
    context "when there is no relevant data" do
      let(:session_data) do
        {
          "student_finance_value" => 0,
          "other_value" => 0,
        }
      end

      it "adds no payments to the payload" do
        service.call(session_data, payload)
        expect(payload.dig(:irregular_incomes, :payments)).to eq([])
      end
    end

    context "when the client is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "adds no payments to the payload" do
        service.call(session_data, payload)
        expect(payload.dig(:irregular_incomes, :payments)).to be_nil
      end
    end

    context "when there is data" do
      let(:session_data) do
        {
          "student_finance_value" => 100,
          "other_value" => 200,
        }
      end

      it "adds data to the payload" do
        service.call(session_data, payload)
        expect(payload.dig(:irregular_incomes, :payments)).to eq(
          [{ amount: 100, frequency: "annual", income_type: "student_loan" },
           { amount: 200, frequency: "quarterly", income_type: "unspecified_source" }],
        )
      end
    end

    context "when there is data for a controlled check" do
      let(:session_data) do
        {
          "student_finance_value" => 100,
          "other_value" => 200,
          "level_of_help" => "controlled",
        }
      end

      it "uses an appropriate frequency" do
        service.call(session_data, payload)
        expect(payload.dig(:irregular_incomes, :payments)).to eq(
          [{ amount: 100, frequency: "annual", income_type: "student_loan" },
           { amount: 200, frequency: "monthly", income_type: "unspecified_source" }],
        )
      end
    end
  end
end
