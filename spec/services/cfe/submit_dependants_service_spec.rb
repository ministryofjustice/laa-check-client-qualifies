require "rails_helper"

RSpec.describe Cfe::SubmitDependantsService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "adult_dependants" => dependant_boolean,
      "child_dependants" => dependant_boolean,
      "child_dependants_count" => child_dependants,
      "adult_dependants_count" => adult_dependants,
    }
  end
  let(:cfe_assessment_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection) }
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }

  describe ".call" do
    before do
      travel_to arbitrary_fixed_time
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    end

    context "when there are 4 dependants" do
      let(:dependant_boolean) { true }
      let(:child_dependants) { 4 }
      let(:adult_dependants) { 1 }

      it "makes a successful call" do
        expect(mock_connection).to receive(:create_dependants) do |estimate_id, params|
          expect(estimate_id).to eq cfe_assessment_id
          expect(params.count).to eq child_dependants + adult_dependants

          valid_child_count = params.count do |item|
            item[:date_of_birth] > 18.years.ago &&
              item[:in_full_time_education] &&
              item[:relationship] == "child_relative" &&
              item[:monthly_income] == 0 &&
              item[:assets_value].zero?
          end

          valid_adult_count = params.count do |item|
            item[:date_of_birth] < 18.years.ago &&
              !item[:in_full_time_education] &&
              item[:relationship] == "adult_relative" &&
              item[:monthly_income] == 0 &&
              item[:assets_value].zero?
          end

          expect(valid_child_count).to eq child_dependants
          expect(valid_adult_count).to eq adult_dependants
        end

        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there are no dependants" do
      let(:dependant_boolean) { false }
      let(:child_dependants) { 4 }
      let(:adult_dependants) { 2 }

      it "does not make a call" do
        expect(mock_connection).not_to receive(:create_dependants)
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when there are zero dependants" do
      let(:dependant_boolean) { true }
      let(:child_dependants) { 0 }
      let(:adult_dependants) { 0 }

      it "does not make a call" do
        expect(mock_connection).not_to receive(:create_dependants)
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end

    context "when the client is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "does not make a call" do
        expect(mock_connection).not_to receive(:create_dependants)
        service.call(mock_connection, cfe_assessment_id, session_data)
      end
    end
  end
end
