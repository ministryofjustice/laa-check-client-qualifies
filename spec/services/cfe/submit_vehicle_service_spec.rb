require "rails_helper"

RSpec.describe Cfe::SubmitVehicleService do
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
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
  end
end
