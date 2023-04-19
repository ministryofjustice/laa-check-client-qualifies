require "rails_helper"

RSpec.describe JourneyLoggerService do
  describe ".call" do
    let(:assessment_id) { "assessment-id" }
    let(:calculation_result) { CalculationResult.new("api_response" => api_result) }
    let(:api_result) { FactoryBot.build(:api_result) }
    let(:check) { Check.new(session_data) }
    let(:session_data) { { level_of_help: "controlled" }.with_indifferent_access }

    it "handles errors without crashing" do
      expect(ErrorService).to receive(:call)
      allow(CompletedUserJourney).to receive(:create!).and_raise "Error!"
      expect { described_class.call(assessment_id, calculation_result, check, {}) }.not_to raise_error
    end

    context "with minimal data" do
      it "saves the right details to the database" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.certificated).to eq false
        expect(output.partner).to eq false
        expect(output.person_over_60).to eq false
        expect(output.passported).to eq false
        expect(output.main_dwelling_owned).to eq false
        expect(output.vehicle_owned).to eq false
        expect(output.smod_assets).to eq false
        expect(output.outcome).to eq "ineligible"
        expect(output.capital_contribution).to eq false
        expect(output.income_contribution).to eq false
      end

      it "skips saving in no-analytics mode" do
        described_class.call(assessment_id, calculation_result, check, { no_analytics_mode: true })
        expect(CompletedUserJourney.count).to eq 0
      end
    end

    context "with a full set of data" do
      let(:session_data) do
        {
          partner: true,
          partner_over_60: true,
          passporting: false,
          level_of_help: "certificated",
          property_owned: "with_mortgage",
          vehicle_owned: true,
          house_in_dispute: true,
        }.with_indifferent_access
      end
      let(:api_result) do
        FactoryBot.build(
          :api_result,
          overall_result: {
            result: "contribution_required",
            income_contribution: 3,
            capital_contribution: 4,
          },
        )
      end

      it "saves the right details to the database" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.certificated).to eq true
        expect(output.partner).to eq true
        expect(output.person_over_60).to eq true
        expect(output.passported).to eq false
        expect(output.main_dwelling_owned).to eq true
        expect(output.vehicle_owned).to eq true
        expect(output.smod_assets).to eq true
        expect(output.outcome).to eq "contribution_required"
        expect(output.capital_contribution).to eq true
        expect(output.income_contribution).to eq true
      end
    end

    context "when the user is passported" do
      let(:session_data) do
        {
          passporting: true,
        }.with_indifferent_access
      end

      it "correctly tracks this" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.passported).to eq true
      end
    end

    context "with an upper tribunal case" do
      let(:session_data) do
        {
          level_of_help: "certificated",
          proceeding_type: "IM030",
          property_owned: "with_mortgage",
          house_in_dispute: true,
        }.with_indifferent_access
      end

      it "correctly identifies that there are no smod assets" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.smod_assets).to eq false
      end
    end

    context "when details change" do
      let(:session_data) { { partner: false } }

      it "updates an existing record" do
        existing_record = FactoryBot.create(:completed_user_journey, assessment_id:, partner: true)
        described_class.call(assessment_id, calculation_result, check, {})
        expect(existing_record.reload.partner).to eq false
      end
    end
  end
end
