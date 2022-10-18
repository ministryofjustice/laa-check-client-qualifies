require "rails_helper"

RSpec.describe SubmitOutgoingsService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "outgoings" => ["", "housing_payments"],
      "housing_payments" => "328.0",
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      describe "with outgoings" do
        it "makes a successful call" do
          expect(mock_connection).to receive(:create_regular_payments).with(cfe_estimate_id, ["", "housing_payments"], 328.0)
          service.call(cfe_estimate_id, session_data)
        end
      end
    end
  end
end
