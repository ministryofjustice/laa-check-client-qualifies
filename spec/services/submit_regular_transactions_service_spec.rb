require "rails_helper"

RSpec.describe SubmitRegularTransactionsService do
  let(:service) { described_class }
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
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

      it "makes a no call" do
        expect(mock_connection).not_to receive(:create_regular_payments)
        service.call(mock_connection, cfe_estimate_id, session_data)
      end
    end
  end
end
