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

    context "when the client is not employed" do
      let(:session_data) { { "employment_status" => "unemployed" } }

      it "does not make a call" do
        expect(mock_connection).not_to receive(:create_employments)
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    # context "when there is a full set of data, which includes tax/income tax/gross income/national insurance as a string including a trailing white space" do
    #   let(:session_data) do
    #     {
    #       "employment_status" => "in_work",
    #       "frequency" => "monthly",
    #       "gross_income" => "122 ", # this is converted to a float in employments.rb
    #       "national_insurance" => "25 ", # this is converted to a float in employments.rb
    #       "income_tax" => "18 ", # this is converted to a float in employments.rb
    #     }
    #   end

    #   it "calls CFE with tax/income tax/gross income/national insurance converted to a float" do
    #     expect(mock_connection).to receive(:create_employments).with(
    #       cfe_assessment_id,
    #       client_id: "ID",
    #       name: "Job",
    #       payments: [{
    #         gross: 122.0,
    #         tax: -18.0,
    #         national_insurance: -25.0,
    #         client_id: "id-0",
    #         date: Date.today,
    #         benefits_in_kind: 0,
    #         net_employment_income: 79.0,
    #       },
    #                  {
    #                    gross: 122.0,
    #                    tax: -18.0,
    #                    national_insurance: -25.0,
    #                    client_id: "id-1",
    #                    date: Time.zone.today - 1.month,
    #                    benefits_in_kind: 0,
    #                    net_employment_income: 79.0,
    #                  },
    #                  {
    #                    gross: 122.0,
    #                    tax: -18.0,
    #                    national_insurance: -25.0,
    #                    client_id: "id-2",
    #                    date: Time.zone.today - 2.months,
    #                    benefits_in_kind: 0,
    #                    net_employment_income: 79.0,
    #                  }],
    #       receiving_only_statutory_sick_or_maternity_pay: false,
    #     )
    #     described_class.call(mock_connection, cfe_assessment_id, session_data)
    #   end
    # end
  end
end
