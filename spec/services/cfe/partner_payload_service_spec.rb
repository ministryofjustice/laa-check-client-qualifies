require "rails_helper"

RSpec.describe Cfe::PartnerPayloadService do
  describe ".call" do
    let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 24, 9, 0, 0) }
    let(:service) { described_class }
    let(:payload) { {} }

    context "with lots of partner info" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_employment_status" => "in_work",
          "partner_over_60" => true,
          "partner_student_finance_value" => 1_000,
          "partner_other_value" => 0,
          "partner_frequency" => "week",
          "partner_gross_income" => 500,
          "partner_income_tax" => 50,
          "partner_national_insurance" => 20,
          "partner_friends_or_family_value" => 100,
          "partner_friends_of_family_value" => "every_week",
          "partner_receives_benefits" => true,
          "partner_benefits" => [
            "benefit_type" => "Child benefit",
            "benefit_frequency" => "every_week",
            "benefit_amount" => 45,
          ],
          "partner_savings" => 1_000,
          "partner_investments" => 250,
          "partner_valuables" => 0,
          "partner_additional_property_owned" => "with_mortgage",
          "partner_additional_house_value" => 100_000,
          "partner_additional_mortgage" => 50_000,
          "partner_additional_percentage_owned" => 100,
        }
      end

      it "constructs a valid payload" do
        described_class.call(session_data, payload)
        partner = payload[:partner]
        expect(partner[:partner]).to eq({ employed: true, date_of_birth: 70.years.ago.to_date })
        expect(partner[:irregular_incomes]).to eq([{ amount: 1_000, frequency: "annual", income_type: "student_loan" }])
        expect(partner[:employments][0][:payments].count).to eq(12)
        expect(partner[:regular_transactions]).to eq([{ amount: 100,
                                                        category: :friends_or_family,
                                                        frequency: nil,
                                                        operation: :credit }])
        expect(partner[:state_benefits][0][:payments].count).to eq(12)
        expect(partner[:additional_properties]).to eq([{ outstanding_mortgage: 50_000,
                                                         percentage_owned: 100,
                                                         shared_with_housing_assoc: false,
                                                         value: 100_000 }])
        expect(partner[:capitals]).to eq({ bank_accounts: [{ description: "Liquid Asset", value: 1_000, subject_matter_of_dispute: false }],
                                           non_liquid_capital: [{ description: "Non Liquid Asset", value: 250, subject_matter_of_dispute: false }] })
        expect(partner[:vehicles]).to eq([])
      end
    end

    context "with minimal partner info" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_over_60" => false,
          "partner_student_finance_value" => 0,
          "partner_other_value" => 0,
          "partner_friends_or_family_value" => 0,
          "partner_benefits" => [],
          "partner_savings" => 0,
          "partner_investments" => 0,
          "partner_valuables" => 0,
          "partner_additional_property_owned" => "none",
        }
      end

      it "constructs a valid payload" do
        described_class.call(session_data, payload)
        partner = payload[:partner]
        expect(partner[:partner]).to eq({ employed: false, date_of_birth: 50.years.ago.to_date })
        expect(partner[:irregular_incomes]).to eq([])
        expect(partner[:employments]).to eq([])
        expect(partner[:regular_transactions]).to eq([])
        expect(partner[:state_benefits]).to eq([])
        expect(partner[:additional_properties]).to eq([])
        expect(partner[:capitals]).to eq({ bank_accounts: [],
                                           non_liquid_capital: [] })
        expect(partner[:vehicles]).to eq([])
      end
    end

    context "with passported partner info" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_over_60" => false,
          "passporting" => true,
          "partner_savings" => 0,
          "partner_investments" => 0,
          "partner_valuables" => 0,
        }
      end

      it "constructs a valid payload" do
        described_class.call(session_data, payload)
        partner = payload[:partner]
        expect(partner[:partner]).to eq({ employed: false, date_of_birth: 50.years.ago.to_date })
        expect(partner[:irregular_incomes]).to eq([])
        expect(partner[:employments]).to eq([])
        expect(partner[:regular_transactions]).to eq([])
        expect(partner[:state_benefits]).to eq([])
        expect(partner[:additional_properties]).to eq([])
        expect(partner[:capitals]).to eq({ bank_accounts: [],
                                           non_liquid_capital: [] })
        expect(partner[:vehicles]).to eq([])
      end
    end

    context "when no partner" do
      let(:session_data) do
        {
          "partner" => false,
        }
      end

      it "adds nothing to the payload" do
        described_class.call(session_data, payload)
        expect(payload[:partner]).to be_nil
      end
    end

    context "with different partner ownership statuses" do
      let(:session_data) do
        {
          "partner" => true,
          "passporting" => true,
          "partner_savings" => 0,
          "partner_investments" => 0,
          "partner_valuables" => 0,
          "partner_additional_property_owned" => ownership_status,
          "partner_additional_house_value" => 100_000,
          "partner_additional_mortgage" => 50_000,
          "partner_additional_percentage_owned" => 100,
        }
      end

      context "with outright-owned second property" do
        let(:ownership_status) { "outright" }

        it "adds details to the payload" do
          described_class.call(session_data, payload)
          partner = payload[:partner]
          expect(partner[:additional_properties]).to eq([{ outstanding_mortgage: 0,
                                                           percentage_owned: 100,
                                                           shared_with_housing_assoc: false,
                                                           value: 100_000 }])
        end
      end

      context "with mortgaged second property" do
        let(:ownership_status) { "with_mortgage" }

        it "adds details to the payload" do
          described_class.call(session_data, payload)
          partner = payload[:partner]
          expect(partner[:additional_properties]).to eq([{ outstanding_mortgage: 50_000,
                                                           percentage_owned: 100,
                                                           shared_with_housing_assoc: false,
                                                           value: 100_000 }])
        end
      end
    end
  end
end
