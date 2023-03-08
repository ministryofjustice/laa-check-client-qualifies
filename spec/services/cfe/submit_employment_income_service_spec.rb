require "rails_helper"

RSpec.describe Cfe::SubmitEmploymentIncomeService do
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
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

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

        it "submits the right number of payments to CFE" do
          expect(mock_connection).to receive(:create_employments) do |_assessment_id, employment_data|
            expect(employment_data.dig(0, :payments).length).to eq scenario[:cfe_payments]
          end
          described_class.call(mock_connection, cfe_assessment_id, session_data)
        end

        it "submits the right amounts to CFE" do
          expect(mock_connection).to receive(:create_employments) do |_assessment_id, employment_data|
            expect(employment_data.dig(0, :payments, 0, :gross)).to eq(gross_income / scenario[:divisor])
          end
          described_class.call(mock_connection, cfe_assessment_id, session_data)
        end
      end
    end
  end
end
