require "rails_helper"

RSpec.describe SubmitProceedingsService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "proceeding_type" => proceeding_type,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data a call to the proceedings endpoint" do
      let(:proceeding_type) { "SE003" }

      it "is successful" do
        expect(mock_connection).to receive(:create_proceeding_type).with(cfe_estimate_id, "SE003")
        service.call(cfe_estimate_id, session_data)
      end
    end
  end
end
