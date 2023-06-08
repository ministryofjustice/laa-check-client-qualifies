require "rails_helper"

RSpec.describe Cfe::RegularTransactionsPayloadService do
  let(:service) { described_class }
  let(:payload) { {} }

  describe ".call" do
    context "when there a full set of relevant data" do
      let(:session_data) do
        {
          "friends_or_family_value" => 45,
          "friends_or_family_frequency" => "every_week",
          "maintenance_value" => 56,
          "maintenance_frequency" => "every_two_weeks",
          "property_or_lodger_value" => 67,
          "property_or_lodger_frequency" => "every_four_weeks",
          "pension_value" => 78,
          "pension_frequency" => "monthly",
          "student_finance_value" => 89,
          "other_value" => 9,
          "housing_payments_value" => 12,
          "housing_payments_frequency" => "every_week",
          "childcare_payments_value" => 23,
          "childcare_payments_frequency" => "every_two_weeks",
          "maintenance_payments_value" => 34,
          "maintenance_payments_frequency" => "total",
          "legal_aid_payments_value" => 46,
          "legal_aid_payments_frequency" => "monthly",
        }
      end

      it "adds an appropriate payload" do
        service.call(session_data, payload)
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
           { amount: 12,
             category: :rent_or_mortgage,
             frequency: :weekly,
             operation: :debit },
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
      let(:session_data) do
        {
          "friends_or_family_value" => "0",
          "pension_value" => "0",
          "maintenance_value" => "0",
          "property_or_lodger_value" => "0",
          "housing_payments_value" => "0",
          "childcare_payments_value" => "0",
          "maintenance_payments_value" => "0",
          "legal_aid_payments_value" => "0",
        }
      end

      it "adds no payments" do
        service.call(session_data, payload)
        expect(payload[:regular_transactions]).to eq([])
      end
    end

    context "when the applicant is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "adds nothing to the payment" do
        service.call(session_data, payload)
        expect(payload[:regular_transactions]).to be_nil
      end
    end

    context "when in the household flow", :household_section_flag do
      context "when client or their partner do not own their home" do
        let(:session_data) do
          {
            "property_owned" => "none",
            "friends_or_family_value" => 45,
            "friends_or_family_frequency" => "every_week",
            "maintenance_value" => 56,
            "maintenance_frequency" => "every_two_weeks",
            "property_or_lodger_value" => 67,
            "property_or_lodger_frequency" => "every_four_weeks",
            "pension_value" => 78,
            "pension_frequency" => "monthly",
            "student_finance_value" => 89,
            "other_value" => 9,
            "childcare_payments_value" => 23,
            "childcare_payments_frequency" => "every_two_weeks",
            "maintenance_payments_value" => 34,
            "maintenance_payments_frequency" => "total",
            "legal_aid_payments_value" => 46,
            "legal_aid_payments_frequency" => "monthly",
            "housing_payments" => 120,
            "housing_payments_frequency" => "monthly",
          }
        end

        it "populates the payload with content from the housing costs screen" do
          service.call(session_data, payload)
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
               operation: :debit }],
          )
        end
      end

      context "when client does not own their home but has no housing costs" do
        let(:session_data) do
          {
            "property_owned" => "none",
            "housing_payments" => 0,
          }
        end

        it "does not include rent or mortgage in the payload" do
          service.call(session_data, payload)
          expect(payload[:regular_transactions]).to eq(
            [],
          )
        end
      end

      context "when there is an invalid frequency" do
        let(:session_data) do
          {
            "property_owned" => "none",
            "housing_payments" => 1,
            "housing_payments_frequency" => "invalid",
          }
        end

        it "raises an error" do
          expect { service.call(session_data, payload) }.to raise_error("key not found: \"invalid\"")
        end
      end

      context "when client or their partner do own their home with mortgage or loan" do
        let(:session_data) do
          {
            "property_owned" => "with_mortgage",
            "housing_loan_payments" => 140,
            "housing_payments_loan_frequency" => "monthly",
          }
        end

        it "populates the payload with content from the mortgage or loan screen" do
          service.call(session_data, payload)
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
          {
            "property_owned" => "with_mortgage",
            "housing_loan_payments" => 0,
            "housing_payments_loan_frequency" => "monthly",
          }
        end

        it "does not populate the payload with content from the mortgage or loan screen" do
          service.call(session_data, payload)
          expect(payload[:regular_transactions]).to eq(
            [],
          )
        end
      end

      context "when client or their partner do own their home outright" do
        let(:session_data) do
          {
            "property_owned" => "outright",
          }
        end

        it "populates the payload with content from the mortgage or loan screen" do
          service.call(session_data, payload)
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

        it "adds nothing to the payment" do
          service.call(session_data, payload)
          expect(payload[:regular_transactions]).to be_nil
        end
      end
    end
  end
end
