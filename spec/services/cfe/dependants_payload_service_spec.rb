require "rails_helper"

RSpec.describe Cfe::DependantsPayloadService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "adult_dependants" => dependant_boolean,
      "child_dependants" => dependant_boolean,
      "child_dependants_count" => child_dependants,
      "adult_dependants_count" => adult_dependants,
    }
  end

  let(:payload) { {} }
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }

  describe ".call" do
    before do
      travel_to arbitrary_fixed_time
    end

    context "when there are 4 dependants" do
      let(:dependant_boolean) { true }
      let(:child_dependants) { 4 }
      let(:adult_dependants) { 1 }

      it "populates the payload successfully" do
        service.call(session_data, payload)
        expect(payload[:dependants].count).to eq child_dependants + adult_dependants

        valid_child_count = payload[:dependants].count do |item|
          item[:date_of_birth] > 18.years.ago &&
            item[:in_full_time_education] &&
            item[:relationship] == "child_relative" &&
            item[:monthly_income] == 0 &&
            item[:assets_value].zero?
        end

        valid_adult_count = payload[:dependants].count do |item|
          item[:date_of_birth] < 18.years.ago &&
            !item[:in_full_time_education] &&
            item[:relationship] == "adult_relative" &&
            item[:monthly_income] == 0 &&
            item[:assets_value].zero?
        end

        expect(valid_child_count).to eq child_dependants
        expect(valid_adult_count).to eq adult_dependants
      end
    end

    context "when there are no dependants" do
      let(:dependant_boolean) { false }
      let(:child_dependants) { 4 }
      let(:adult_dependants) { 2 }

      it "does not populate the payload" do
        service.call(session_data, payload)
        expect(payload[:dependants]).to eq []
      end
    end

    context "when there are zero dependants" do
      let(:dependant_boolean) { true }
      let(:child_dependants) { 0 }
      let(:adult_dependants) { 0 }

      it "does not populate the payload" do
        service.call(session_data, payload)
        expect(payload[:dependants]).to eq []
      end
    end

    context "when the client is passported" do
      let(:session_data) do
        {
          "passporting" => true,
        }
      end

      it "does not populate the payload" do
        service.call(session_data, payload)
        expect(payload[:dependants]).to be_nil
      end
    end
  end
end
