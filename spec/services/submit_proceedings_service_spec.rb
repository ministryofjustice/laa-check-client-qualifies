require "rails_helper"

RSpec.describe SubmitProceedingsService do
  let(:service) { described_class }
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }

  describe ".call" do
    context "when there is no controlled/certificated flag" do
      let(:session_data) do
        {
          "proceeding_type" => "foo",
        }
      end

      it "uses the specified proceeding type" do
        expect(mock_connection).to receive(:create_proceeding_type).with(cfe_estimate_id, "foo")
        service.call(mock_connection, cfe_estimate_id, session_data)
      end
    end
  end
end
