require "rails_helper"

RSpec.describe Cfe::VehiclePayloadService do
  let(:payload) { {} }

  describe ".call" do
    context "when there are multiple vehicles" do
      let(:session_data) do
        {
          "vehicle_owned" => true,
          "vehicles" => [
            {
              "vehicle_value" => 5556,
              "vehicle_pcp" => true,
              "vehicle_finance" => 4445,
              "vehicle_over_3_years_ago" => true,
              "vehicle_in_regular_use" => false,
              "vehicle_in_dispute" => true,
            },
            {
              "vehicle_value" => 1112,
              "vehicle_pcp" => false,
              "vehicle_finance" => 888,
              "vehicle_over_3_years_ago" => false,
              "vehicle_in_regular_use" => true,
              "vehicle_in_dispute" => false,
            },
          ],
        }
      end

      it "sets the payload appropriately" do
        described_class.call(session_data, payload)
        expect(payload[:vehicles]).to eq(
          [
            { date_of_purchase: 4.years.ago.to_date,
              in_regular_use: false,
              loan_amount_outstanding: 4445,
              subject_matter_of_dispute: true,
              value: 5556 },
            { date_of_purchase: 2.years.ago.to_date,
              in_regular_use: true,
              loan_amount_outstanding: 0,
              subject_matter_of_dispute: false,
              value: 1112 },
          ],
        )
      end
    end

    context "when the client is asylum supported" do
      let(:session_data) do
        {
          "proceeding_type" => "IM030",
          "asylum_support" => true,
        }
      end

      it "does not set the payload" do
        described_class.call(session_data, payload)
        expect(payload[:vehicles]).to be_nil
      end
    end

    context "when vehicle marked as SMOD, but SMOD does not apply" do
      let(:session_data) do
        FactoryBot.build(:minimal_complete_session,
                         vehicle_owned: true,
                         vehicles: [
                           {
                             "vehicle_value" => 5556,
                             "vehicle_pcp" => true,
                             "vehicle_finance" => 4445,
                             "vehicle_over_3_years_ago" => true,
                             "vehicle_in_regular_use" => false,
                             "vehicle_in_dispute" => true,
                           },
                         ],
                         proceeding_type: "IM030")
      end

      it "does not add SMOD to the payload" do
        described_class.call(session_data, payload)
        expect(payload.dig(:vehicles, 0, :subject_matter_of_dispute)).to eq false
      end
    end
  end
end
