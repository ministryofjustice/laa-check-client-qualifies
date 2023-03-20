require "rails_helper"

RSpec.describe MetricsService do
  describe ".call" do
    let(:client) { instance_double(Geckoboard::Client, datasets: dataset_client) }
    let(:dataset_client) { instance_double(Geckoboard::DatasetsClient) }
    let(:metric_dataset) { instance_double(Geckoboard::Dataset) }
    let(:all_metric_dataset) { instance_double(Geckoboard::Dataset) }
    let(:last_page_dataset) { instance_double(Geckoboard::Dataset) }
    let(:recent_validation_dataset) { instance_double(Geckoboard::Dataset) }
    let(:all_validation_dataset) { instance_double(Geckoboard::Dataset) }
    let(:arbitrary_fixed_time) { "2023-3-20" }

    before { travel_to arbitrary_fixed_time }

    context "when api key is not set" do
      it "does nothing" do
        expect(Geckoboard).not_to receive(:client)
        described_class.call
      end
    end

    context "when api key is set" do
      around do |example|
        ENV["GECKOBOARD_ENABLED"] = "enabled"
        example.run
        ENV["GECKOBOARD_API_KEY"] = nil
      end

      before do
        allow(Geckoboard).to receive(:client).and_return(client)
        allow(dataset_client).to receive(:find_or_create) do |dataset_name, _|
          case dataset_name
          when "monthly_metrics"
            metric_dataset
          when "all_metrics"
            all_metric_dataset
          when "last_pages"
            last_page_dataset
          when "recent_validations"
            recent_validation_dataset
          when "all_validations"
            all_validation_dataset
          end
        end
      end

      context "when there is no relevant data" do
        it "pushes appropriate numbers to Geckoboard" do
          expect(metric_dataset).to receive(:put).with([])
          expect(all_metric_dataset).to receive(:put).with([
            {
              certificated_checks_completed: 0,
              checks_completed: 0,
              checks_started: 0,
              completed_checks_per_user: nil,
              completion_rate: nil,
              controlled_checks_completed: 0,
              date: Date.current,
            },
          ])
          expect(recent_validation_dataset).to receive(:put).with([])
          expect(all_validation_dataset).to receive(:put).with([])
          expect(last_page_dataset).to receive(:put).with([])
          described_class.call
        end
      end

      context "when there is relevant data" do
        before do
          # Completed certificated assessment by user 1
          create :analytics_event, assessment_code: "CODE1", page: "applicant", browser_id: "BROWSER1", created_at: 1.month.ago
          create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.month.ago
          create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.month.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.month.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE1", page: "view_results", browser_id: "BROWSER1", created_at: 1.month.ago

          # Completed certificated assessment by user 1
          create :analytics_event, assessment_code: "CODE2", page: "applicant", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE2", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE2", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE2", page: "view_results", browser_id: "BROWSER1", created_at: 1.day.ago

          # Incomplete certificated assessment by user 1
          create :analytics_event, assessment_code: "CODE3", event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice", browser_id: "BROWSER1", created_at: 1440.minutes.ago
          create :analytics_event, assessment_code: "CODE3", page: "applicant", browser_id: "BROWSER1", created_at: 1439.minutes.ago
          create :analytics_event, assessment_code: "CODE3", page: "outgoings", browser_id: "BROWSER1", created_at: 1438.minutes.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE3", page: "vehicle", browser_id: "BROWSER1", created_at: 1437.minutes.ago

          # Completed controlled assessment by user 2
          create :analytics_event, assessment_code: "CODE4", page: "applicant", browser_id: "BROWSER2", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE4", page: "view_results", browser_id: "BROWSER2", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE4", event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice", browser_id: "BROWSER2", created_at: 1.day.ago

          # Completed controlled assessment
          create :analytics_event, assessment_code: "CODE5", event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE5", page: "applicant", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE5", page: "view_results", created_at: 1.day.ago

          create :analytics_event, page: "index_start"
        end

        it "pushes appropriate numbers to Geckoboard" do
          expect(all_metric_dataset).to receive(:put).with(
            [
              { certificated_checks_completed: 2,
                checks_completed: 4,
                checks_started: 5,
                completed_checks_per_user: 2,
                completion_rate: 80,
                controlled_checks_completed: 2,
                date: Date.current },
            ],
          )
          expect(metric_dataset).to receive(:put).with(
            [
              {
                certificated_checks_completed: 1,
                checks_completed: 1,
                checks_started: 1,
                completed_checks_per_user: 1,
                completion_rate: 100,
                controlled_checks_completed: 0,
                date: Date.new(2023, 2, 1),
              },
              {
                certificated_checks_completed: 1,
                checks_completed: 3,
                checks_started: 4,
                completed_checks_per_user: 2,
                completion_rate: 75,
                controlled_checks_completed: 2,
                date: Date.new(2023, 3, 1),
              },
            ],
          )
          expect(recent_validation_dataset).to receive(:put).with(
            [
              {
                checks: 1,
                screen: "outgoings",
              },
              {
                checks: 1,
                screen: "vehicle",
              },
            ],
          )
          expect(all_validation_dataset).to receive(:put).with(
            [
              {
                checks: 2,
                screen: "vehicle",
              },
              {
                checks: 1,
                screen: "outgoings",
              },
            ],
          )
          expect(last_page_dataset).to receive(:put).with(
            [
              { checks: 1, context: "controlled_all_time", screen: "vehicle" },
              { checks: 1, context: "controlled_current_month", screen: "vehicle" },
            ],
          )
          described_class.call
        end
      end
    end
  end
end
