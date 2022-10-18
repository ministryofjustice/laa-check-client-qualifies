require "rails_helper"

RSpec.describe SubmitPropertyService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "property_owned" => "with_mortgage",
      "house_value" => "234000.0",
      "mortgage" => "189000.0",
      "percentage_owned" => 50,
    }
  end
  let(:cfe_estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }

  describe ".call" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when it is passed valid data" do
      describe "with a main home with a mortgage" do
        let(:value) { "234000.0" }
        let(:outstanding_mortgage) { "189000.0" }
        let(:percentage_owned) { 50 }
        let(:main_home) do
          { value: value.to_d,
            outstanding_mortgage: outstanding_mortgage.to_d,
            percentage_owned: }
        end

        it "makes a successful call" do
          expect(mock_connection).to receive(:create_properties).with(cfe_estimate_id, main_home, nil)
          service.call(cfe_estimate_id, session_data)
        end
      end
    end
  end
end
