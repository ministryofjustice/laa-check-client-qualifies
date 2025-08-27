require "rails_helper"

RSpec.describe JourneyLoggerService do
  describe ".call" do
    let(:assessment_id) { "assessment-id" }
    let(:calculation_result) { CalculationResult.new("api_response" => api_result) }
    let(:api_result) { FactoryBot.build(:api_result) }
    let(:check) { Check.new(session_data) }
    let(:session_data) { { level_of_help: "controlled", immigration_or_asylum: true, immigration_or_asylum_type: "asylum" }.with_indifferent_access }

    it "handles errors without crashing", :throws_cfe_error do
      expect(ErrorService).to receive(:call)
      allow(CompletedUserJourney).to receive(:create!).and_raise "Error!"
      expect { described_class.call(assessment_id, calculation_result, check, {}) }.not_to raise_error
    end

    context "with minimal data" do
      it "saves the right details to the database" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.certificated).to be false
        expect(output.partner).to be false
        expect(output.passported).to be false
        expect(output.main_dwelling_owned).to be false
        expect(output.vehicle_owned).to be false
        expect(output.smod_assets).to be false
        expect(output.outcome).to eq "ineligible"
        expect(output.capital_contribution).to be false
        expect(output.income_contribution).to be false
        expect(output.asylum_support).to be false
        expect(output.matter_type).to eq "asylum"
        expect(output.session.with_indifferent_access).to eq session_data
        expect(output.office_code).to be_nil
        expect(output.early_result_type).to be_nil
        expect(output.early_eligibility_result).to be false
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
        expect(output.certificated).to be true
        expect(output.partner).to be true
        expect(output.person_over_60).to be true
        expect(output.passported).to be false
        expect(output.main_dwelling_owned).to be true
        expect(output.vehicle_owned).to be true
        expect(output.smod_assets).to be true
        expect(output.outcome).to eq "contribution_required"
        expect(output.capital_contribution).to be true
        expect(output.income_contribution).to be true
        expect(output.early_result_type).to be_nil
        expect(output.early_eligibility_result).to be false
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
        expect(output.passported).to be true
      end
    end

    context "with an upper tribunal case" do
      let(:session_data) do
        {
          level_of_help: "certificated",
          immigration_or_asylum_type_upper_tribunal: "immigration_upper",
          property_owned: "with_mortgage",
          house_in_dispute: true,
          asylum_support: false,
        }.with_indifferent_access
      end

      it "correctly identifies that there are no smod assets" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.smod_assets).to be false
        expect(output.asylum_support).to be false
      end

      context "when asylum supported" do
        let(:session_data) do
          {
            level_of_help: "certificated",
            immigration_or_asylum_type_upper_tribunal: "immigration_upper",
            asylum_support: true,
          }.with_indifferent_access
        end

        it "tracks asylum support" do
          described_class.call(assessment_id, calculation_result, check, {})
          output = CompletedUserJourney.find_by(assessment_id:)
          expect(output.asylum_support).to be true
        end
      end

      context "when an asylum upper tribunal case" do
        let(:session_data) do
          {
            level_of_help: "certificated",
            immigration_or_asylum_type_upper_tribunal: "asylum_upper",
            asylum_support: false,
          }.with_indifferent_access
        end

        it "tracks it as an asylum upper tribunal case" do
          described_class.call(assessment_id, calculation_result, check, {})
          output = CompletedUserJourney.find_by(assessment_id:)
          expect(output.matter_type).to eq "asylum"
        end
      end

      context "when a domestic abuse case" do
        let(:session_data) do
          {
            level_of_help: "certificated",
            domestic_abuse_applicant: true,
            asylum_support: false,
          }.with_indifferent_access
        end

        it "tracks a domestic abuse case" do
          described_class.call(assessment_id, calculation_result, check, {})
          output = CompletedUserJourney.find_by(assessment_id:)
          expect(output.matter_type).to eq "domestic_abuse"
        end
      end
    end

    context "when client is over 60" do
      let(:session_data) { { "client_age" => "over_60" } }

      it "saves age to the completed user journey" do
        described_class.call(assessment_id, calculation_result, check, session_data)
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.client_age).to eq "over_60"
      end
    end

    context "when it is an early ineligible result for gross income" do
      let(:session_data) do
        {
          immigration_or_asylum: false,
          partner: false,
          passporting: false,
          early_result: { "result" => "ineligible",
                          "type" => "gross_income" },
        }.with_indifferent_access
      end

      it "saves `early_result_type` and `outcome` to completed user journey" do
        described_class.call(assessment_id, calculation_result, check, {})
        output = CompletedUserJourney.find_by(assessment_id:)
        expect(output.outcome).to eq "ineligible"
        expect(output.early_result_type).to eq "gross_income"
        expect(output.early_eligibility_result).to be true
      end
    end

    context "when the journey continues after early ineligible result" do
      let(:session_data) do
        {
          early_result: { "result" => "ineligible",
                          "type" => "gross_income" },
        }.with_indifferent_access
      end

      it "creates a new record at the end of the journey" do
        # Initial call with ineligible early eligibility result from session_data
        described_class.call(assessment_id, calculation_result, check, {})
        expect(CompletedUserJourney.where(assessment_id:).count).to eq 1
        # Simulate continuing to the end of the journey with an overall_result
        updated_api_result = FactoryBot.build(:api_result, overall_result: { result: "ineligible" })
        allow(calculation_result).to receive(:api_response).and_return(updated_api_result)
        # Update `check` to alter `early_result_type` as a visit to the results page would
        allow(check).to receive(:early_ineligible_result?).and_return(nil)
        described_class.call(assessment_id, calculation_result, check, {})
        expect(CompletedUserJourney.where(assessment_id:).count).to eq 2
      end
    end

    context "when CompletedUserJourney is called with the same assessment_id and early_ineligible remains true" do
      let(:session_data) do
        {
          immigration_or_asylum: false,
          partner: false,
          passporting: false,
          early_result: { "result" => "ineligible",
                          "type" => "gross_income" },
        }.with_indifferent_access
      end

      it "creates a new record initially, and updates it on subsequent calls" do
        described_class.call(assessment_id, calculation_result, check, session_data)
        expect(CompletedUserJourney.where(assessment_id:).count).to eq 1

        modified_session_data = {
          immigration_or_asylum: true,
          partner: true,
          passporting: true,
          early_result: { "result" => "ineligible", "type" => "gross_income" },
        }.with_indifferent_access

        described_class.call(assessment_id, calculation_result, check, modified_session_data)

        # Ensure no new record was created; the count should still be 1
        expect(CompletedUserJourney.where(assessment_id:).count).to eq 1
      end
    end

    context "when details change in a full journey" do
      let(:session_data) { { partner: false } }

      it "updates an existing record" do
        existing_record = FactoryBot.create(:completed_user_journey, assessment_id:, early_eligibility_result: false, partner: true)
        described_class.call(assessment_id, calculation_result, check, {})
        expect(existing_record.reload.partner).to be false
      end
    end

    context "when users skips to results page, after they see the early ineligible banner" do
      let(:session_data) do
        {
          early_result: { "result" => "ineligible",
                          "type" => "gross_income" },
        }
      end

      it "updates an existing record" do
        existing_record = FactoryBot.create(:completed_user_journey, assessment_id:, early_eligibility_result: true)
        described_class.call(assessment_id, calculation_result, check, {})
        expect(existing_record.reload.early_eligibility_result).to be true
      end
    end
  end
end
