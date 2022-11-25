require "rails_helper"

RSpec.describe SubmitPartnerService, :partner_flag do
  describe ".call" do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 24, 9, 0, 0) }
    let(:service) { described_class }
    let(:cfe_assessment_id) { SecureRandom.uuid }
    let(:mock_connection) { instance_double(CfeConnection) }

    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "with lots of partner info" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_employed" => true,
          "partner_over_60" => true,
          "partner_student_finance_value" => 1_000,
          "partner_other_income_value" => 500,
          "partner_frequency" => "week",
          "partner_gross_income" => 500,
          "partner_income_tax" => 50,
          "partner_national_insurance" => 20,
          "partner_housing_payments_value" => 100,
          "partner_housing_payments_frequency" => "every_week",
          "partner_friends_or_family_value" => 100,
          "partner_friends_of_family_value" => "every_week",
          "partner_benefits" => [
            "benefit_type" => "Child benefit",
            "benefit_frequency" => "every_week",
            "benefit_amount" => 45,
          ],
          "partner_property_value" => 100_000,
          "partner_property_mortgage" => 50_000,
          "partner_property_percentage_owned" => 100,
          "partner_savings" => 1_000,
          "partner_investments" => 250,
          "partner_vehicle_owned" => true,
          "partner_vehicle_value" => 5000,
          "partner_vehicle_outstanding_finance" => false,
          "partner_vehicle_over_3_years_ago" => true,
          "partner_vehicle_in_regular_use" => false,
        }
      end

      it "constructs a valid payload to send to CFE" do
        expect(mock_connection).to receive(:create_partner) do |assessment_id, payload|
          expect(assessment_id).to eq cfe_assessment_id
          expect(payload[:partner]).to eq({ employed: true, date_of_birth: 70.years.ago.to_date })
          expect(payload[:irregular_incomes]).to eq([{ amount: 1_000, frequency: "annual", income_type: "student_loan" }])
          expect(payload[:employments][0][:payments].count).to eq(12)
          expect(payload[:regular_transactions]).to eq([{ amount: 100,
                                                          category: :friends_or_family,
                                                          frequency: nil,
                                                          operation: :credit },
                                                        { amount: 100,
                                                          category: :rent_or_mortgage,
                                                          frequency: :weekly,
                                                          operation: :debit }])
          expect(payload[:state_benefits][0][:payments].count).to eq(12)
          expect(payload[:additional_properties]).to eq([{ outstanding_mortgage: 50_000,
                                                           percentage_owned: 100,
                                                           shared_with_housing_assoc: false,
                                                           value: 100_000 }])
          expect(payload[:capitals]).to eq({ bank_accounts: [{ description: "Liquid Asset", value: 1_000, subject_matter_of_dispute: false }],
                                             non_liquid_capital: [{ description: "Non Liquid Asset", value: 250, subject_matter_of_dispute: false }] })
          expect(payload[:vehicles]).to eq([{ date_of_purchase: 4.years.ago.to_date,
                                              in_regular_use: false,
                                              loan_amount_outstanding: 0,
                                              value: 5_000,
                                              subject_matter_of_dispute: false }])
        end
        described_class.call(cfe_assessment_id, session_data)
      end
    end

    context "with minimal partner info" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_employed" => false,
          "partner_over_60" => false,
          "partner_student_finance_value" => 0,
          "partner_housing_payments_value" => 0,
          "partner_friends_or_family_value" => 0,
          "partner_benefits" => [],
          "partner_property_value" => 0,
          "partner_savings" => 0,
          "partner_investments" => 0,
          "partner_vehicle_owned" => false,
        }
      end

      it "constructs a valid payload to send to CFE" do
        expect(mock_connection).to receive(:create_partner) do |assessment_id, payload|
          expect(assessment_id).to eq cfe_assessment_id
          expect(payload[:partner]).to eq({ employed: false, date_of_birth: 50.years.ago.to_date })
          expect(payload[:irregular_incomes]).to eq([])
          expect(payload[:employments]).to eq([])
          expect(payload[:regular_transactions]).to eq([])
          expect(payload[:state_benefits]).to eq([])
          expect(payload[:additional_properties]).to eq([])
          expect(payload[:capitals]).to eq({ bank_accounts: [],
                                             non_liquid_capital: [] })
          expect(payload[:vehicles]).to eq([])
        end
        described_class.call(cfe_assessment_id, session_data)
      end
    end
  end
end
