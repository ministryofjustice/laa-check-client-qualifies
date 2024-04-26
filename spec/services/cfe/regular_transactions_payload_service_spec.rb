require "rails_helper"

RSpec.describe Cfe::RegularTransactionsPayloadService do
  let(:service) { described_class }
  let(:payload) { {} }
  let(:empty_session_data) do
    {
      "friends_or_family_relevant" => false,
      "maintenance_relevant" => false,
      "property_or_lodger_relevant" => false,
      "pension_relevant" => false,
      "housing_payments_value" => 0,
      "childcare_payments_relevant" => false,
      "maintenance_payments_relevant" => false,
      "legal_aid_payments_relevant" => false,
      "student_finance_relevant" => false,
      "other_relevant" => false,
      "housing_payments" => 0,
      "housing_benefit_relevant" => false,
    }
  end
  let(:relevant_steps) { %i[other_income outgoings] }

  describe ".call" do
    context "when there a full set of income and outgoings data" do
      let(:session_data) do
        {
          "friends_or_family_relevant" => true,
          "maintenance_relevant" => true,
          "property_or_lodger_relevant" => true,
          "pension_relevant" => true,
          "student_finance_relevant" => true,
          "other_relevant" => true,
          "friends_or_family_conditional_value" => 45,
          "friends_or_family_frequency" => "every_week",
          "maintenance_conditional_value" => 56,
          "maintenance_frequency" => "every_two_weeks",
          "property_or_lodger_conditional_value" => 67,
          "property_or_lodger_frequency" => "every_four_weeks",
          "pension_conditional_value" => 78,
          "pension_frequency" => "monthly",
          "student_finance_conditional_value" => 89,
          "other_conditional_value" => 9,
          "childcare_payments_relevant" => true,
          "maintenance_payments_relevant" => true,
          "legal_aid_payments_relevant" => true,
          "childcare_payments_conditional_value" => 23,
          "childcare_payments_frequency" => "every_two_weeks",
          "maintenance_payments_conditional_value" => 34,
          "maintenance_payments_frequency" => "total",
          "legal_aid_payments_conditional_value" => 46,
          "legal_aid_payments_frequency" => "monthly",
          "housing_payments" => 0,
          "housing_benefit_relevant" => false,
        }
      end

      it "adds an appropriate payload" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:regular_transactions]).to eq(
          [{ amount: 45,
             category: :friends_or_family,
             frequency: :weekly,
             operation: :credit },
           { amount: 56,
             category: :maintenance_in,
             frequency: :two_weekly,
             operation: :credit },
           { amount: 67,
             category: :property_or_lodger,
             frequency: :four_weekly,
             operation: :credit },
           { amount: 78,
             category: :pension,
             frequency: :monthly,
             operation: :credit },
           { amount: 23,
             category: :child_care,
             frequency: :two_weekly,
             operation: :debit },
           { amount: 34,
             category: :maintenance_out,
             frequency: :three_monthly,
             operation: :debit },
           { amount: 46,
             category: :legal_aid,
             frequency: :monthly,
             operation: :debit }],
        )
      end
    end

    context "when there is no relevant data" do
      let(:session_data) { empty_session_data }
      let(:relevant_steps) { [:other_income] }

      it "adds no payments" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:regular_transactions]).to eq([])
      end
    end

    context "when there is benefits data" do
      let(:session_data) do
        empty_session_data.merge(
          "receives_benefits" => true,
          "benefits" => [
            { "benefit_type" => "Child Benefit",
              "benefit_amount" => 100,
              "benefit_frequency" => "every_two_weeks" },
            { "benefit_type" => "Tax Credit",
              "benefit_amount" => 50,
              "benefit_frequency" => "every_week" },
          ],
        )
      end
      let(:relevant_steps) { [:benefit_details] }

      it "adds benefit payments" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:regular_transactions]).to eq(
          [
            { amount: 100,
              category: "benefits",
              frequency: :two_weekly,
              operation: :credit },
            { amount: 50,
              category: "benefits",
              frequency: :weekly,
              operation: :credit },
          ],
        )
      end
    end

    context "when the applicant is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end
      let(:relevant_steps) { [] }

      it "adds nothing to the payment" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:regular_transactions]).to be_nil
      end
    end

    context "when client or their partner do not own their home" do
      let(:session_data) do
        {
          "property_owned" => "none",
          "friends_or_family_relevant" => true,
          "maintenance_relevant" => true,
          "property_or_lodger_relevant" => true,
          "pension_relevant" => true,
          "student_finance_relevant" => true,
          "other_relevant" => true,
          "friends_or_family_conditional_value" => 45,
          "friends_or_family_frequency" => "every_week",
          "maintenance_conditional_value" => 56,
          "maintenance_frequency" => "every_two_weeks",
          "property_or_lodger_conditional_value" => 67,
          "property_or_lodger_frequency" => "every_four_weeks",
          "pension_conditional_value" => 78,
          "pension_frequency" => "monthly",
          "student_finance_conditional_value" => 89,
          "other_conditional_value" => 9,
          "childcare_payments_relevant" => true,
          "maintenance_payments_relevant" => true,
          "legal_aid_payments_relevant" => true,
          "childcare_payments_conditional_value" => 23,
          "childcare_payments_frequency" => "every_two_weeks",
          "maintenance_payments_conditional_value" => 34,
          "maintenance_payments_frequency" => "total",
          "legal_aid_payments_conditional_value" => 46,
          "legal_aid_payments_frequency" => "monthly",
          "housing_payments" => 120,
          "housing_payments_frequency" => "monthly",
          "housing_benefit_value" => 119,
          "housing_benefit_frequency" => "monthly",
          "housing_benefit_relevant" => true,
        }
      end
      let(:relevant_steps) { %i[outgoings partner_outgoings housing_costs other_income] }

      it "populates the payload with content from the housing costs screen" do
        service.call(session_data, payload, relevant_steps)
        expect(payload[:regular_transactions]).to eq(
          [{ amount: 45,
             category: :friends_or_family,
             frequency: :weekly,
             operation: :credit },
           { amount: 56,
             category: :maintenance_in,
             frequency: :two_weekly,
             operation: :credit },
           { amount: 67,
             category: :property_or_lodger,
             frequency: :four_weekly,
             operation: :credit },
           { amount: 78,
             category: :pension,
             frequency: :monthly,
             operation: :credit },
           { amount: 23,
             category: :child_care,
             frequency: :two_weekly,
             operation: :debit },
           { amount: 34,
             category: :maintenance_out,
             frequency: :three_monthly,
             operation: :debit },
           { amount: 46,
             category: :legal_aid,
             frequency: :monthly,
             operation: :debit },
           { amount: 120,
             category: :rent_or_mortgage,
             frequency: :monthly,
             operation: :debit },
           { amount: 119,
             category: :housing_benefit,
             frequency: :monthly,
             operation: :credit }],
        )
      end

      context "when client does not own their home but has no housing costs" do
        let(:session_data) do
          empty_session_data.merge({
            "property_owned" => "none",
            "housing_payments" => 0,
          })
        end
        let(:relevant_steps) { %i[property housing_costs] }

        it "does not include rent or mortgage in the payload" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:regular_transactions]).to eq(
            [],
          )
        end
      end

      context "when there is an invalid frequency" do
        let(:session_data) do
          empty_session_data.merge({
            "property_owned" => "none",
            "housing_payments" => 1,
            "housing_payments_frequency" => "invalid",
          })
        end
        let(:relevant_steps) { %i[property housing_costs] }

        it "raises an error" do
          expect { service.call(session_data, payload, relevant_steps) }.to raise_error(
            "Invalid session detected by HousingCostsForm:\n  Housing payments frequency Select frequency of housing payments.",
          )
        end
      end

      context "when client or their partner do own their home with mortgage or loan" do
        let(:session_data) do
          empty_session_data.merge({
            "property_owned" => "with_mortgage",
            "housing_loan_payments" => 140,
            "housing_payments_loan_frequency" => "monthly",
          })
        end
        let(:relevant_steps) { %i[property mortgage_or_loan_payment] }

        it "populates the payload with content from the mortgage or loan screen" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:regular_transactions]).to eq(
            [{ amount: 140,
               category: :rent_or_mortgage,
               frequency: :monthly,
               operation: :debit }],
          )
        end
      end

      context "when client owns their home with mortgage but it has zero payments" do
        let(:session_data) do
          empty_session_data.merge({
            "property_owned" => "with_mortgage",
            "housing_loan_payments" => 0,
            "housing_payments_loan_frequency" => "monthly",
          })
        end
        let(:relevant_steps) { %i[property mortgage_or_loan_payment] }

        it "does not populate the payload with content from the mortgage or loan screen" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:regular_transactions]).to eq(
            [],
          )
        end
      end

      context "when client or their partner do own their home outright" do
        let(:session_data) do
          empty_session_data.merge({
            "property_owned" => "outright",
          })
        end
        let(:relevant_steps) { %i[other_income property] }

        it "populates the payload with content from the mortgage or loan screen" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:regular_transactions]).to eq(
            [],
          )
        end
      end

      context "when the applicant is passported" do
        let(:session_data) do
          {
            "passporting" => true,
          }
        end
        let(:relevant_steps) { [] }

        it "adds nothing to the payment" do
          service.call(session_data, payload, relevant_steps)
          expect(payload[:regular_transactions]).to be_nil
        end
      end
    end
  end
end
