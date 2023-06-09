require "rails_helper"

RSpec.describe Cfe::ProceedingsPayloadService do
  let(:service) { described_class }
  let(:payload) { {} }

  describe ".call" do
    let(:session_data) do
      {
        "level_of_help" => "controlled",
        "matter_type" => "other",
      }
    end

    it "uses the specified proceeding type" do
      service.call(session_data, payload)
      expect(payload[:proceeding_types]).to eq(
        [{
          ccms_code: "SE003",
          client_involvement_type: "A",
        }],
      )
    end
  end
end
