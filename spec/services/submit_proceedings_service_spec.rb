require "rails_helper"

RSpec.describe SubmitProceedingsService do
  let(:service) { described_class }
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when there is no controlled/certificated flag" do
      let(:session_data) do
        {
          "legacy_proceeding_type" => "foo",
        }
      end

      it "uses the specified proceeding type" do
        expect(mock_connection).to receive(:create_proceeding_type).with(cfe_estimate_id, "foo")
        service.call(mock_connection, cfe_estimate_id, session_data)
      end
    end

    context "when the a&i flag is on", :controlled_flag, :asylum_and_immigration_flag do
      let(:session_data) do
        {
          "level_of_help" => "controlled",
          "proceeding_type" => "bar",
        }
      end

      it "uses the specified proceeding type" do
        expect(mock_connection).to receive(:create_proceeding_type).with(cfe_estimate_id, "bar")
        service.call(mock_connection, cfe_estimate_id, session_data)
      end
    end
  end
end
