require "rails_helper"

RSpec.describe Metrics::ForUserJourneyDashboardService do
  describe ".call" do
    let(:client) { instance_double(Geckoboard::Client, datasets: dataset_client) }
    let(:dataset_client) { instance_double(Geckoboard::DatasetsClient) }
    let(:dataset) { instance_double(Geckoboard::Dataset) }

    before do
      allow(Geckoboard).to receive(:client).and_return(client)
      allow(dataset_client).to receive(:find_or_create).and_return(dataset)
    end

    context "when there is no relevant data" do
      it "does not interact with Geckoboard" do
        expect(Geckoboard).not_to receive(:client)
        described_class.call
      end
    end

    context "when there is relevant data" do
      shared_examples "an aggregator" do |prefix, criteria|
        before do
          create_list :completed_user_journey, 3, **criteria.merge(certificated: true, completed: 1.month.ago)
          create_list :completed_user_journey, 1, **criteria.merge(certificated: false, completed: 1.month.ago)
          create_list :completed_user_journey, 5, **criteria.merge(certificated: true, completed: Time.current)
          create_list :completed_user_journey, 6, **criteria.merge(certificated: false, completed: Time.current)

          # Create some rows that should _not_ be included in the aggregation
          inverse = criteria.dup
          key_to_swap = inverse.keys.first
          inverse[key_to_swap] = if inverse[key_to_swap].in? [true, false]
                                   !inverse[key_to_swap]
                                 else
                                   "something_else"
                                 end

          create_list :completed_user_journey, 9, **inverse.merge(certificated: true, completed: 1.month.ago)
        end

        it "pushes appropriate numbers to Geckoboard" do
          expect(dataset).to receive(:put) do |rows|
            expect(rows.find { _1[:property] == prefix && _1[:metric_variant] == "Certificated all time" }[:checks]).to eq 8
            expect(rows.find { _1[:property] == prefix && _1[:metric_variant] == "Controlled all time" }[:checks]).to eq 7
            expect(rows.find { _1[:property] == prefix && _1[:metric_variant] == "Certificated this month" }[:checks]).to eq 5
            expect(rows.find { _1[:property] == prefix && _1[:metric_variant] == "Controlled this month" }[:checks]).to eq 6
          end
          described_class.call
        end
      end

      it_behaves_like "an aggregator", "with_partner", partner: true
      it_behaves_like "an aggregator", "no_partner", partner: false
      it_behaves_like "an aggregator", "over_60", person_over_60: true
      it_behaves_like "an aggregator", "passported", passported: true
      it_behaves_like "an aggregator", "non_passported", passported: false
      it_behaves_like "an aggregator", "property", main_dwelling_owned: true
      it_behaves_like "an aggregator", "vehicle", vehicle_owned: true
      it_behaves_like "an aggregator", "smod", smod_assets: true
      it_behaves_like "an aggregator", "form_downloaded", form_downloaded: true
      it_behaves_like "an aggregator", "asylum_support", asylum_support: true
      it_behaves_like "an aggregator", "no_asylum_support", asylum_support: false
      it_behaves_like "an aggregator", "domestic_abuse_matter", matter_type: "domestic_abuse"
      it_behaves_like "an aggregator", "other_matter", matter_type: "other"
      it_behaves_like "an aggregator", "immigration_matter", matter_type: "immigration"
      it_behaves_like "an aggregator", "asylum_matter", matter_type: "asylum"
      it_behaves_like "an aggregator", "eligible", outcome: "eligible"
      it_behaves_like "an aggregator", "ineligible", outcome: "ineligible"
      it_behaves_like "an aggregator", "capital_contribution", outcome: "contribution_required", capital_contribution: true
      it_behaves_like "an aggregator", "income_contribution", outcome: "contribution_required", income_contribution: true
    end
  end
end
