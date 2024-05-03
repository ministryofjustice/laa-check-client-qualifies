require "rails_helper"

RSpec.describe Cfe::IrregularIncomePayloadService do
  let(:service) { described_class }
  let(:payload) { {} }
  let(:regular_income_session_data) do
    {
      "friends_or_family_relevant" => false,
      "maintenance_relevant" => false,
      "property_or_lodger_relevant" => false,
      "pension_relevant" => false,
    }
  end
  let(:relevant_steps) { [:other_income] }

  describe ".call" do
    context "when there is no relevant data" do
      let(:session_data) do
        {
          "student_finance_relevant" => false,
          "other_relevant" => false,
        }.merge(regular_income_session_data)
      end

      it "adds no payments to the payload" do
        # they have seen the form - they have filled it in with 0
        service.call(session_data, payload, relevant_steps)
        expect(payload.dig(:irregular_incomes, :payments)).to eq([])
      end
    end

    context "when the client is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end
      let(:relevant_steps) { [] }

      it "adds no payments to the payload" do
        # they haven't seen the form
        service.call(session_data, payload, relevant_steps)
        expect(payload.dig(:irregular_incomes, :payments)).to be_nil
      end
    end

    context "when there is data" do
      let(:session_data) do
        {
          "student_finance_relevant" => true,
          "other_relevant" => true,
          "student_finance_conditional_value" => 100,
          "other_conditional_value" => 200,
        }.merge(regular_income_session_data)
      end

      it "adds data to the payload" do
        service.call(session_data, payload, relevant_steps)
        expect(payload.dig(:irregular_incomes, :payments)).to eq(
          [{ amount: 100, frequency: "annual", income_type: "student_loan" },
           { amount: 200, frequency: "quarterly", income_type: "unspecified_source" }],
        )
      end
    end

    context "when there is data for a controlled check" do
      let(:session_data) do
        {
          "student_finance_relevant" => true,
          "other_relevant" => true,
          "student_finance_conditional_value" => 100,
          "other_conditional_value" => 200,
          "level_of_help" => "controlled",
        }.merge(regular_income_session_data)
      end

      it "uses an appropriate frequency" do
        service.call(session_data, payload, relevant_steps)
        expect(payload.dig(:irregular_incomes, :payments)).to eq(
          [{ amount: 100, frequency: "annual", income_type: "student_loan" },
           { amount: 200, frequency: "monthly", income_type: "unspecified_source" }],
        )
      end
    end
  end
end
