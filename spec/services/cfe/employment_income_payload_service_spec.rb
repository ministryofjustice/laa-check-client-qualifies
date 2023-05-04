require "rails_helper"

RSpec.describe Cfe::EmploymentIncomePayloadService do
  let(:session_data) do
    {
      "employment_status" => "in_work",
      "frequency" => frequency,
      "gross_income" => gross_income,
      "national_insurance" => 20,
      "income_tax" => 10,
    }
  end
  let(:gross_income) { 12 }
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
