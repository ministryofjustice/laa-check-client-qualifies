require "rails_helper"

RSpec.describe Cfe::PartnerPayloadService do
  describe ".call" do
    let(:service) { described_class }
    let(:payload) { {} }
    let(:minimal_partner_info) do
      {
        "partner" => true,
        "partner_over_60" => false,
        "partner_employment_status" => "unemployed",
        "partner_student_finance_relevant" => false,
        "partner_other_relevant" => false,
        "partner_friends_or_family_relevant" => false,
        "partner_maintenance_relevant" => false,
        "partner_property_or_lodger_relevant" => false,
        "partner_pension_relevant" => false,
        "partner_benefits" => [],
        "partner_bank_accounts" => [{ "amount" => 0 }],
        "partner_investments_relevant" => false,
        "partner_valuables_relevant" => false,
        "partner_additional_property_owned" => "none",
        "partner_childcare_payments_relevant" => false,
        "partner_maintenance_payments_relevant" => false,
        "partner_legal_aid_payments_relevant" => false,
      }
    end

    context "with lots of partner info" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_employment_status" => "unemployed",
          "partner_over_60" => true,
          "partner_student_finance_relevant" => true,
          "partner_student_finance_conditional_value" => 1_000,
          "partner_other_relevant" => false,
          "partner_gross_income" => 500,
          "partner_income_tax" => 50,
          "partner_national_insurance" => 20,
          "partner_frequency" => "week",
          "partner_friends_or_family_relevant" => true,
          "partner_friends_or_family_conditional_value" => 100,
          "partner_friends_or_family_frequency" => "every_week",
          "partner_maintenance_relevant" => false,
          "partner_property_or_lodger_relevant" => false,
          "partner_pension_relevant" => false,
          "partner_receives_benefits" => true,
          "partner_benefits" => [
            "benefit_type" => "Child benefit",
            "benefit_frequency" => "every_week",
            "benefit_amount" => 45,
          ],
          "partner_bank_accounts" => [{ "amount" => 1_000 }],
          "partner_childcare_payments_relevant" => false,
          "partner_maintenance_payments_relevant" => false,
          "partner_legal_aid_payments_relevant" => false,
          "partner_investments_relevant" => true,
          "partner_investments" => 250,
          "partner_valuables_relevant" => false,
          "partner_additional_property_owned" => "with_mortgage",
          "partner_additional_properties" => [{
            "house_value" => 100_000,
            "mortgage" => 50_000,
            "percentage_owned" => 100,
          }],
        }
      end

      it "constructs a valid payload" do
        described_class.call(session_data, payload, %i[partner_details
                                                       partner_benefits
                                                       partner_benefit_details
                                                       partner_other_income
                                                       partner_assets
                                                       partner_additional_property_details])
        partner = payload[:partner]
        expect(partner[:partner]).to eq({ employed: false, date_of_birth: 70.years.ago.to_date })
        expect(partner[:irregular_incomes]).to eq([{ amount: 1_000, frequency: "annual", income_type: "student_loan" }])
        expect(partner[:regular_transactions]).to eq([{ amount: 100,
                                                        category: :friends_or_family,
                                                        frequency: :weekly,
                                                        operation: :credit },
                                                      { amount: 45,
                                                        category: "benefits",
                                                        frequency: :weekly,
                                                        operation: :credit }])
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
      let(:session_data) { minimal_partner_info }

      it "constructs a valid payload" do
        described_class.call(session_data, payload, %i[partner_details partner_assets])
        partner = payload[:partner]
        expect(partner[:partner]).to eq({ employed: false, date_of_birth: 50.years.ago.to_date })
        expect(partner[:irregular_incomes]).to eq([])
        expect(partner[:employment_details]).to eq([])
        expect(partner[:regular_transactions]).to eq([])
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
          "partner_bank_accounts" => [{ "amount" => 0 }],
          "partner_investments_relevant" => false,
          "partner_valuables_relevant" => false,
        }
      end

      it "constructs a valid payload" do
        described_class.call(session_data, payload, %i[partner_details partner_assets])
        partner = payload[:partner]
        expect(partner[:partner]).to eq({ employed: false, date_of_birth: 50.years.ago.to_date })
        expect(partner[:irregular_incomes]).to eq([])
        expect(partner[:employment_details]).to eq([])
        expect(partner[:regular_transactions]).to eq([])
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
        described_class.call(session_data, payload, %i[])
        expect(payload[:partner]).to be_nil
      end
    end

    context "with partner outgoings" do
      let(:session_data) do
        minimal_partner_info.merge(
          {
            "partner_maintenance_payments_relevant" => true,
            "partner_maintenance_payments_conditional_value" => 34,
            "partner_maintenance_payments_frequency" => "total",
          },
        )
      end

      it "adds details to the payload" do
        described_class.call(session_data, payload, %i[partner_details partner_outgoings])
        partner = payload[:partner]
        expect(partner[:regular_transactions]).to eq([{ amount: 34, category: :maintenance_out, frequency: :three_monthly, operation: :debit }])
      end
    end

    context "with different partner ownership statuses" do
      let(:session_data) do
        {
          "partner" => true,
          "partner_over_60" => false,
          "passporting" => true,
          "partner_bank_accounts" => [{ "amount" => 0 }],
          "partner_investments_relevant" => false,
          "partner_valuables_relevant" => false,
          "partner_additional_property_owned" => ownership_status,
          "partner_additional_properties" => [{
            "house_value" => 100_000,
            "mortgage" => 50_000,
            "percentage_owned" => 100,
          }],
        }
      end

      context "with outright-owned second property" do
        let(:ownership_status) { "outright" }

        it "adds details to the payload" do
          described_class.call(session_data, payload, %i[partner_details partner_additional_property_details])
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
          described_class.call(session_data, payload, %i[partner_details partner_additional_property_details])
          partner = payload[:partner]
          expect(partner[:additional_properties]).to eq([{ outstanding_mortgage: 50_000,
                                                           percentage_owned: 100,
                                                           shared_with_housing_assoc: false,
                                                           value: 100_000 }])
        end
      end
    end

    context "when dealing with employment data" do
      context "when the partner is not employed" do
        let(:session_data) { minimal_partner_info.merge({ "partner_employment_status" => "unemployed" }) }

        it "does not populate any payload" do
          described_class.call(session_data, payload, %i[partner_details partner_employment_status])
          expect(payload[:partner][:employment_details]).to eq []
          expect(payload[:partner][:self_employment_details]).to eq []
        end
      end

      context "when the partner has employments" do
        let(:session_data) do
          minimal_partner_info.merge({
            "partner_employment_status" => "in_work",
            "partner_incomes" => [
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
          })
        end

        it "populates the employment payload" do
          described_class.call(session_data, payload, %i[partner_details partner_employment_status partner_income])
          expect(payload[:partner][:employment_details]).to eq(
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
          described_class.call(session_data, payload, %i[partner_details partner_employment_status partner_income])
          expect(payload[:partner][:self_employment_details]).to eq(
            [
              { income: { frequency: "three_monthly", gross: 500, tax: -100, national_insurance: -0 } },
            ],
          )
        end
      end
    end
  end
end
