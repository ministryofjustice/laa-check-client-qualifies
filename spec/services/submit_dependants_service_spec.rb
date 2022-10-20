require "rails_helper"

RSpec.describe SubmitDependantsService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "dependants" => dependant_boolean,
      "dependant_count" => dependants,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      describe "it makes a successful call with 4 dependants" do
        let(:dependant_boolean) { true }
        let(:dependants) { 4 }

        it "makes a successful call" do
          expect(mock_connection).to receive(:create_dependants).with(cfe_estimate_id, 4)
          service.call(cfe_estimate_id, session_data)
        end
      end

      describe "when there are no dependants" do
        let(:dependant_boolean) { false }
        let(:dependants) { nil }

        it "does not make a call" do
          expect(mock_connection).not_to receive(:create_dependants)
          service.call(cfe_estimate_id, session_data)
        end
      end
    end
  end
end
