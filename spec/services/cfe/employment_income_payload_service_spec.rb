require "rails_helper"

RSpec.describe Cfe::EmploymentIncomePayloadService do
  context "when the self-employment flag is not enabled" do
    let(:session_data) do
      {
        "over_60" => false,
        "passporting" => false,
        "partner" => false,
        "employment_status" => "in_work",
        "frequency" => frequency,
        "gross_income" => gross_income,
        "national_insurance" => 20,
        "income_tax" => 10,
      }
    end
    let(:gross_income) { 120 }
    let(:payload) { {} }

    describe ".call" do
      [
        { frequency: "week", cfe_payments: 12, divisor: 1 },
        { frequency: "two_weeks", cfe_payments: 6, divisor: 1 },
        { frequency: "four_weeks", cfe_payments: 3, divisor: 1 },
        { frequency: "monthly", cfe_payments: 3, divisor: 1 },
        { frequency: "total", cfe_payments: 3, divisor: 3 },
      ].each do |scenario|
        context "with #{scenario[:frequency]} payment frequency" do
          let(:frequency) { scenario[:frequency] }

          it "adds the right number of payments to the payload" do
            described_class.call(session_data, payload)
            expect(payload.dig(:employment_income, 0, :payments).length).to eq scenario[:cfe_payments]
          end

          it "adds the right amounts to the payload" do
            described_class.call(session_data, payload)
            expect(payload.dig(:employment_income, 0, :payments, 0, :gross)).to eq(gross_income / scenario[:divisor])
          end
        end
      end

      context "when the client is not employed" do
        let(:session_data) { { "employment_status" => "unemployed" } }

        it "does not populate the payload" do
          described_class.call(session_data, payload)
          expect(payload[:employment_income]).to be_nil
        end
      end
    end
  end

  context "when the self-employment flag is enabled", :self_employed_flag do
    let(:payload) { {} }

    before { described_class.call(session_data, payload) }

    context "when the client is not employed" do
      let(:session_data) { { "employment_status" => "unemployed" } }

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
  end
end
