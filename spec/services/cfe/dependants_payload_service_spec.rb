require "rails_helper"

RSpec.describe Cfe::DependantsPayloadService do
  let(:service) { described_class }
  let(:session_data) do
    {
      "adult_dependants" => dependant_boolean,
      "child_dependants" => dependant_boolean,
      "child_dependants_count" => child_dependants,
      "adult_dependants_count" => adult_dependants,
      "dependants_get_income" => dependants_get_income,
      "dependant_incomes" => dependant_incomes,
    }
  end

  let(:payload) { {} }
  let(:early_eligibility) { false }
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 10, 17, 9, 0, 0) }

  describe ".call" do
    before do
      travel_to arbitrary_fixed_time
    end

    context "when there are 4 dependants" do
      let(:dependant_boolean) { true }
      let(:child_dependants) { 4 }
      let(:adult_dependants) { 1 }
      let(:dependants_get_income) { false }
      let(:dependant_incomes) { nil }

      it "populates the payload successfully" do
        service.call(session_data, payload, early_eligibility)
        expect(payload[:dependants].count).to eq child_dependants + adult_dependants

        valid_child_count = payload[:dependants].count do |item|
          item[:date_of_birth] > 18.years.ago &&
            item[:in_full_time_education] &&
            item[:relationship] == "child_relative" &&
            item[:income].nil? &&
            item[:assets_value].zero?
        end

        valid_adult_count = payload[:dependants].count do |item|
          item[:date_of_birth] < 18.years.ago &&
            !item[:in_full_time_education] &&
            item[:relationship] == "adult_relative" &&
            item[:income].nil? &&
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
      let(:dependants_get_income) { false }
      let(:dependant_incomes) { nil }

      it "does not populate the payload" do
        service.call(session_data, payload, early_eligibility)
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
        service.call(session_data, payload, early_eligibility)
        expect(payload[:dependants]).to be_nil
      end
    end

    context "when the dependants have income" do
      let(:dependant_boolean) { true }
      let(:child_dependants) { 2 }
      let(:adult_dependants) { 1 }
      let(:dependants_get_income) { true }
      let(:dependant_incomes) do
        [
          { "amount" => 1, "frequency" => "every_week" },
          { "amount" => 2, "frequency" => "every_two_weeks" },
        ]
      end

      it "adds incomes to the right places" do
        service.call(session_data, payload, early_eligibility)
        expect(payload[:dependants].count).to eq child_dependants + adult_dependants

        adult_with_income = payload[:dependants].find do |item|
          item[:date_of_birth] < 18.years.ago &&
            item[:income] == { frequency: "weekly", amount: 1 }
        end

        child_with_income = payload[:dependants].find do |item|
          item[:date_of_birth] > 18.years.ago &&
            item[:income] == { frequency: "two_weekly", amount: 2 }
        end

        child_without_income = payload[:dependants].find do |item|
          item[:date_of_birth] > 18.years.ago &&
            item[:income].nil?
        end

        expect(adult_with_income).to be_present
        expect(child_with_income).to be_present
        expect(child_without_income).to be_present
      end
    end
  end
end
