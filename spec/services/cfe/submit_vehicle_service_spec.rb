require "rails_helper"

RSpec.describe Cfe::SubmitVehicleService do
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when there is vehicle data" do
      let(:session_data) do
        {
          "vehicle_owned" => true,
          "vehicle_value" => 5556,
          "vehicle_pcp" => true,
          "vehicle_finance" => 4445,
          "vehicle_over_3_years_ago" => true,
          "vehicle_in_regular_use" => false,
          "vehicle_in_dispute" => true,
        }
      end

      it "calls CFE appropriately" do
        expect(mock_connection).to receive(:create_vehicles).with(
          cfe_assessment_id,
          [{ date_of_purchase: 4.years.ago.to_date,
             in_regular_use: false,
             loan_amount_outstanding: 4445,
             subject_matter_of_dispute: true,
             value: 5556 }],
        )
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when the client is asylum supported" do
      let(:session_data) do
        {
          "proceeding_type" => "IM030",
          "asylum_support" => true,
        }
      end

      it "does not call CFE" do
        expect(mock_connection).not_to receive(:create_vehicles)
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when vehicle marked as SMOD, but SMOD does not apply" do
      let(:session_data) do
        FactoryBot.build(:basic_session,
                         :with_vehicle,
                         vehicle_in_dispute: true,
                         proceeding_type: "IM030")
      end

      it "does not tell CFE about SMOD" do
        expect(mock_connection).to receive(:create_vehicles) do |_cfe_assessment_id, params|
          expect(params.dig(0, :subject_matter_of_dispute)).to eq false
        end
        described_class.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
