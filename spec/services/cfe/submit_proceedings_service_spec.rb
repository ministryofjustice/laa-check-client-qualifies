require "rails_helper"

RSpec.describe Cfe::SubmitProceedingsService do
  let(:service) { described_class }
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when there is no controlled/certificated flag" do
      let(:session_data) do
        {
          "legacy_proceeding_type" => "foo",
        }
      end

      it "uses the specified proceeding type" do
        payload = {
          ccms_code: "foo",
          client_involvement_type: "A",
        }
        expect(mock_connection).to receive(:create_proceeding_types).with(cfe_assessment_id, [payload])
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there is a controlled flag and the work is controlled" do
      let(:session_data) do
        {
          "level_of_help" => "controlled",
          "legacy_proceeding_type" => "foo",
          "proceeding_type" => "bar",
        }
      end

      it "uses the default type" do
        payload = {
          ccms_code: "SE003",
          client_involvement_type: "A",
        }
        expect(mock_connection).to receive(:create_proceeding_types).with(cfe_assessment_id, [payload])
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when the a&i flag is on", :asylum_and_immigration_flag do
      let(:session_data) do
        {
          "level_of_help" => "controlled",
          "proceeding_type" => "bar",
        }
      end

      it "uses the specified proceeding type" do
        payload = {
          ccms_code: "bar",
          client_involvement_type: "A",
        }
        expect(mock_connection).to receive(:create_proceeding_types).with(cfe_assessment_id, [payload])
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
