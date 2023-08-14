require "rails_helper"

RSpec.describe Metrics::ForUserJourneyDashboardService do
  describe ".call" do
    let(:client) { instance_double(Geckoboard::Client, datasets: dataset_client) }
    let(:dataset_client) { instance_double(Geckoboard::DatasetsClient) }
    let(:all_journey_dataset) { instance_double(Geckoboard::Dataset) }
    let(:recent_journey_dataset) { instance_double(Geckoboard::Dataset) }
    let(:monthly_journey_dataset) { instance_double(Geckoboard::Dataset) }
    let(:arbitrary_fixed_time) { "2023-7-20" }

    before do
      travel_to arbitrary_fixed_time
      allow(Geckoboard).to receive(:client).and_return(client)
      allow(dataset_client).to receive(:find_or_create) do |dataset_name, _|
        case dataset_name
        when "all_journeys"
          all_journey_dataset
        when "recent_journeys"
          recent_journey_dataset
        when "monthly_journeys"
          monthly_journey_dataset
        end
      end
    end

    context "when there is no relevant data" do
      it "does not interact with Geckoboard" do
        expect(Geckoboard).not_to receive(:client)
        described_class.call
      end
    end

    context "when there is relevant data" do
      before do
        create_list :completed_user_journey, 2, completed: 60.days.ago, certificated: false,
                                                outcome: "contribution_required", income_contribution: true, capital_contribution: true,
                                                partner: false, person_over_60: true, passported: false, matter_type: "immigration_clr"
        create_list :completed_user_journey, 5, completed: 60.days.ago, certificated: true,
                                                outcome: "eligible", income_contribution: false, capital_contribution: false,
                                                partner: true, person_over_60: false, passported: true, matter_type: "asylum"
        create_list :completed_user_journey, 3, completed: 60.days.ago, certificated: true,
                                                outcome: "contribution_required", income_contribution: true, capital_contribution: true,
                                                partner: false, person_over_60: true, passported: false, matter_type: "immigration"
        create_list :completed_user_journey, 7, completed: 60.days.ago, certificated: false,
                                                outcome: "ineligible", income_contribution: false, capital_contribution: false,
                                                partner: false, person_over_60: false, passported: true, matter_type: "asylum"
        create_list :completed_user_journey, 4, completed: 35.days.ago, certificated: false,
                                                outcome: "ineligible", income_contribution: false, capital_contribution: false,
                                                partner: true, person_over_60: true, passported: false, matter_type: "other"
        create_list :completed_user_journey, 6, completed: 20.days.ago, certificated: true,
                                                outcome: "eligible", income_contribution: false, capital_contribution: false,
                                                partner: false, person_over_60: false, passported: true, matter_type: "domestic_abuse"
      end

      it "sends appropriate data to Geckoboard" do
        expect(all_journey_dataset).to receive(:put).with(
          [
            {
              certificated_asylum: 36,
              certificated_capital_contribution: 21,
              certificated_domestic_abuse: 43,
              certificated_eligible_no_contribution: 79,
              certificated_immigration: 21,
              certificated_income_contribution: 21,
              certificated_ineligible: 0,
              certificated_other: 0,
              certificated_over_60: 21,
              certificated_partner: 36,
              certificated_passported: 79,
              combined_capital_contribution: 19,
              combined_eligible_including_contributions: 59,
              combined_eligible_no_contribution: 41,
              combined_income_contribution: 19,
              combined_ineligible: 41,
              combined_over_60: 33,
              combined_partner: 33,
              combined_passported: 67,
              controlled_asylum: 54,
              controlled_eligible: 0,
              controlled_immigration: 15,
              controlled_ineligible: 85,
              controlled_other: 31,
              controlled_over_60: 46,
              controlled_partner: 31,
              controlled_passported: 54,
            },
          ],
        )

        expect(recent_journey_dataset).to receive(:put).with(
          [
            {
              certificated_asylum: 0,
              certificated_capital_contribution: 0,
              certificated_domestic_abuse: 100,
              certificated_eligible_no_contribution: 100,
              certificated_immigration: 0,
              certificated_income_contribution: 0,
              certificated_ineligible: 0,
              certificated_other: 0,
              certificated_over_60: 0,
              certificated_partner: 0,
              certificated_passported: 100,
              combined_capital_contribution: 0,
              combined_eligible_including_contributions: 100,
              combined_eligible_no_contribution: 100,
              combined_income_contribution: 0,
              combined_ineligible: 0,
              combined_over_60: 0,
              combined_partner: 0,
              combined_passported: 100,
              controlled_asylum: nil,
              controlled_eligible: nil,
              controlled_immigration: nil,
              controlled_ineligible: nil,
              controlled_other: nil,
              controlled_over_60: nil,
              controlled_partner: nil,
              controlled_passported: nil,
            },
          ],
        )
        expect(monthly_journey_dataset).to receive(:put).with(
          [
            {
              certificated_asylum: 5,
              certificated_capital_contribution: 3,
              certificated_domestic_abuse: 0,
              certificated_eligible_no_contribution: 5,
              certificated_immigration: 3,
              certificated_income_contribution: 3,
              certificated_ineligible: 0,
              certificated_other: 0,
              certificated_over_60: 3,
              certificated_partner: 5,
              certificated_passported: 5,
              combined_capital_contribution: 5,
              combined_eligible_including_contributions: 10,
              combined_eligible_no_contribution: 5,
              combined_income_contribution: 5,
              combined_ineligible: 7,
              combined_over_60: 5,
              combined_partner: 5,
              combined_passported: 12,
              controlled_asylum: 7,
              controlled_eligible: 0,
              controlled_immigration: 2,
              controlled_ineligible: 7,
              controlled_other: 0,
              controlled_over_60: 2,
              controlled_partner: 0,
              controlled_passported: 7,
              date: Date.new(2023, 5, 1),
            },
            {
              certificated_asylum: 0,
              certificated_capital_contribution: 0,
              certificated_domestic_abuse: 6,
              certificated_eligible_no_contribution: 6,
              certificated_immigration: 0,
              certificated_income_contribution: 0,
              certificated_ineligible: 0,
              certificated_other: 0,
              certificated_over_60: 0,
              certificated_partner: 0,
              certificated_passported: 6,
              combined_capital_contribution: 0,
              combined_eligible_including_contributions: 6,
              combined_eligible_no_contribution: 6,
              combined_income_contribution: 0,
              combined_ineligible: 4,
              combined_over_60: 4,
              combined_partner: 4,
              combined_passported: 6,
              controlled_asylum: 0,
              controlled_eligible: 0,
              controlled_immigration: 0,
              controlled_ineligible: 4,
              controlled_other: 4,
              controlled_over_60: 4,
              controlled_partner: 4,
              controlled_passported: 0,
              date: Date.new(2023, 6, 1),
            },
            {
              certificated_asylum: 0,
              certificated_capital_contribution: 0,
              certificated_domestic_abuse: 0,
              certificated_eligible_no_contribution: 0,
              certificated_immigration: 0,
              certificated_income_contribution: 0,
              certificated_ineligible: 0,
              certificated_other: 0,
              certificated_over_60: 0,
              certificated_partner: 0,
              certificated_passported: 0,
              combined_capital_contribution: 0,
              combined_eligible_including_contributions: 0,
              combined_eligible_no_contribution: 0,
              combined_income_contribution: 0,
              combined_ineligible: 0,
              combined_over_60: 0,
              combined_partner: 0,
              combined_passported: 0,
              controlled_asylum: 0,
              controlled_eligible: 0,
              controlled_immigration: 0,
              controlled_ineligible: 0,
              controlled_other: 0,
              controlled_over_60: 0,
              controlled_partner: 0,
              controlled_passported: 0,
              date: Date.new(2023, 7, 1),
            },
          ],
        )
        described_class.call
      end
    end
  end
end
