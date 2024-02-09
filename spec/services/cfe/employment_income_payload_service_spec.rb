require "rails_helper"

RSpec.describe Cfe::EmploymentIncomePayloadService do
  let(:payload) { {} }

  before { described_class.call(session_data, payload, relevant_steps) }

  context "when the client is not employed" do
    let(:session_data) { { "employment_status" => "unemployed" } }
    let(:relevant_steps) { [:employment_status] }

    it "does not populate any payload" do
      expect(payload[:employment]).to be_nil
      expect(payload[:self_employment]).to be_nil
    end
  end

  context "when the client has employments" do
    let(:session_data) do
      {
        "employment_status" => "in_work",
        "incomes" => [
          {
            "income_type" => "employment",
            "income_frequency" => "monthly",
            "gross_income" => 100,
            "income_tax" => 20,
            "national_insurance" => 3,
          },
          {
            "income_type" => "statutory_pay",
            "income_frequency" => "year",
            "gross_income" => 100,
            "income_tax" => 0,
            "national_insurance" => 0,
          },
          {
            "income_type" => "self_employment",
            "income_frequency" => "three_months",
            "gross_income" => 500,
            "income_tax" => 100,
            "national_insurance" => 0,
          },
        ],
      }
    end
    let(:relevant_steps) { [:income] }

    it "populates the employment payload" do
      expect(payload[:employment_details]).to eq(
        [
          { income: { frequency: "monthly",
                      gross: 100,
                      benefits_in_kind: 0,
                      tax: -20,
                      national_insurance: -3,
                      receiving_only_statutory_sick_or_maternity_pay: false } },
          { income: { frequency: "annually",
                      gross: 100,
                      benefits_in_kind: 0,
                      tax: -0.0,
                      national_insurance: -0.0,
                      receiving_only_statutory_sick_or_maternity_pay: true } },
        ],
      )
    end

    it "populates the self-employment payload" do
      expect(payload[:self_employment_details]).to eq(
        [
          { income: { frequency: "three_monthly", gross: 500, tax: -100, national_insurance: -0 } },
        ],
      )
    end
  end

  context "when the data contains incohesive information" do
    let(:session_data) do
      {
        "employment_status" => "unemployed",
        "incomes" => [
          {
            "income_type" => "employment",
            "income_frequency" => "monthly",
            "gross_income" => 100,
            "income_tax" => 20,
            "national_insurance" => 3,
          },
          {
            "income_type" => "statutory_pay",
            "income_frequency" => "year",
            "gross_income" => 100,
            "income_tax" => 0,
            "national_insurance" => 0,
          },
          {
            "income_type" => "self_employment",
            "income_frequency" => "three_months",
            "gross_income" => 500,
            "income_tax" => 100,
            "national_insurance" => 0,
          },
        ],
      }
    end
    let(:relevant_steps) { %i[employment_status income] }

    it "returns a result which defers to the employment status" do
      expect(payload[:employment]).to be_nil
    end
  end
end
