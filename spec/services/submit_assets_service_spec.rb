require "rails_helper"

RSpec.describe SubmitAssetsService do
  let(:service) { described_class }
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      let(:session_data) do
        {
          "assets" => ["", "valuables"],
          "savings" => nil,
          "investments" => nil,
          "valuables" => "550.0",
        }
      end

      describe "when applicant has valuables over £500" do
        it "makes a successful call" do
          expect(mock_connection).to receive(:create_capitals).with(cfe_estimate_id, [], [550.0])
          expect(mock_connection).not_to receive(:create_properties)
          service.call(cfe_estimate_id, session_data)
        end
      end
    end

    context "when it is passed valid data with a second property" do
      let(:session_data) do
        {
          "property_owned" => "with_mortgage",
          "house_value" => "234000.0",
          "mortgage" => "189000.0",
          "percentage_owned" => 50,
          "assets" => ["", "property", "valuables"],
          "savings" => nil,
          "investments" => nil,
          "valuables" => "550.0",
          "property_value" => "125000.0",
          "property_mortgage" => "100000.0",
          "property_percentage_owned" => 50,
        }
      end

      describe "when applicant has valuables over £500 and a property" do
        it "makes a successful call" do
          expect(mock_connection).to receive(:create_capitals).with(cfe_estimate_id, [], [550.0])
          expect(mock_connection).to receive(:create_properties).with(cfe_estimate_id, { outstanding_mortgage: 189_000,
                                                                                         percentage_owned: 50,
                                                                                         value: 234_000 },
                                                                      { outstanding_mortgage: 100_000,
                                                                        percentage_owned: 50,
                                                                        value: 125_000 })
          service.call(cfe_estimate_id, session_data)
        end
      end
    end
  end
end
