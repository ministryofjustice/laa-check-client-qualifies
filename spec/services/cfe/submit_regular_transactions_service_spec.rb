require "rails_helper"

RSpec.describe Cfe::SubmitRegularTransactionsService do
  let(:service) { described_class }
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

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

      it "calls CFE appropriately" do
        expect(mock_connection).to receive(:create_regular_transactions).with(
          cfe_assessment_id,
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
        service.call(mock_connection, cfe_assessment_id, session_data)
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

      it "makes no call" do
        expect(mock_connection).not_to receive(:create_regular_transactions)
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when the applicant is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "sends nothing to CFE" do
        expect(mock_connection).not_to receive(:create_partner_financials)
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
