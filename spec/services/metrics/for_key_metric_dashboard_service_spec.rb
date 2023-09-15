require "rails_helper"

RSpec.describe Metrics::ForKeyMetricDashboardService do
  describe ".call" do
    let(:client) { instance_double(Geckoboard::Client, datasets: dataset_client) }
    let(:dataset_client) { instance_double(Geckoboard::DatasetsClient) }
    let(:metric_dataset) { instance_double(Geckoboard::Dataset) }
    let(:all_metric_dataset) { instance_double(Geckoboard::Dataset) }
    let(:validation_dataset) { instance_double(Geckoboard::Dataset) }
    let(:last_page_dataset) { instance_double(Geckoboard::Dataset) }
    let(:arbitrary_fixed_time) { "2023-7-20" }

    before do
      travel_to arbitrary_fixed_time
      allow(Geckoboard).to receive(:client).and_return(client)
      allow(dataset_client).to receive(:find_or_create) do |dataset_name, _|
        case dataset_name
        when "monthly_metrics"
          metric_dataset
        when "all_metrics"
          all_metric_dataset
        when "validations"
          validation_dataset
        when "last_pages"
          last_page_dataset
        end
      end
    end

    context "when there is no relevant data" do
      it "pushes appropriate numbers to Geckoboard" do
        expect(metric_dataset).to receive(:put).with([])
        expect(all_metric_dataset).to receive(:put).with([
          {
            median_completion_time_controlled: nil,
            median_completion_time_certificated: nil,
            certificated_checks_completed: 0,
            checks_completed: 0,
            checks_started: 0,
            completed_checks_per_user: nil,
            completion_rate: nil,
            controlled_checks_completed: 0,
            date: Date.current,
            forms_downloaded: 0,
            forms_percentage: nil,
          },
        ])
        expect(validation_dataset).to receive(:put).with([])
        expect(last_page_dataset).to receive(:put).with([])
        described_class.call
      end
    end

    context "when there is relevant data" do
      before do
        # Completed certificated assessment by user 1
        create :analytics_event, assessment_code: "CODE1", page: "level_of_help", browser_id: "BROWSER1", created_at: 32.days.ago
        create :analytics_event, assessment_code: "CODE1", event_type: "certificated_level_of_help_chosen", page: "level_of_help_choice", browser_id: "BROWSER1", created_at: 1.month.ago
        create :analytics_event, assessment_code: "CODE1", page: "applicant", browser_id: "BROWSER1", created_at: 1.month.ago
        create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.month.ago
        create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.month.ago, event_type: "validation_message"
        create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.month.ago, event_type: "validation_message"
        create :analytics_event, assessment_code: "CODE1", page: "view_results", browser_id: "BROWSER1", created_at: 1.month.ago

        # Completed certificated assessment by user 1
        create :analytics_event, assessment_code: "CODE2", page: "level_of_help", browser_id: "BROWSER1", created_at: 26.hours.ago
        # add second level_of_help event to check that the oldest is used as the starting point
        create :analytics_event, assessment_code: "CODE2", page: "level_of_help", browser_id: "BROWSER1", created_at: 25.hours.ago
        create :analytics_event, assessment_code: "CODE2", event_type: "certificated_level_of_help_chosen", page: "level_of_help_choice", browser_id: "BROWSER1", created_at: 25.hours.ago
        create :analytics_event, assessment_code: "CODE2", page: "applicant", browser_id: "BROWSER1", created_at: 1.day.ago
        create :analytics_event, assessment_code: "CODE2", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago, event_type: "validation_message"
        create :analytics_event, assessment_code: "CODE2", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago
        create :analytics_event, assessment_code: "CODE2", page: "view_results", browser_id: "BROWSER1", created_at: 1.day.ago
        # add second view_results event to check that the earliest is used as the end date
        create :analytics_event, assessment_code: "CODE2", page: "view_results", browser_id: "BROWSER1", created_at: 12.hours.ago

        # Incomplete certificated assessment by user 1
        create :analytics_event, assessment_code: "CODE3", event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice", browser_id: "BROWSER1", created_at: 1440.minutes.ago
        create :analytics_event, assessment_code: "CODE3", page: "applicant", browser_id: "BROWSER1", created_at: 1439.minutes.ago
        create :analytics_event, assessment_code: "CODE3", page: "outgoings", browser_id: "BROWSER1", created_at: 1438.minutes.ago, event_type: "validation_message"
        create :analytics_event, assessment_code: "CODE3", page: "vehicle", browser_id: "BROWSER1", created_at: 1437.minutes.ago

        # Completed controlled assessment by user 2
        create :analytics_event, assessment_code: "CODE4", page: "level_of_help", browser_id: "BROWSER2", created_at: 22.hours.ago
        create :analytics_event, assessment_code: "CODE4", event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice", browser_id: "BROWSER1", created_at: 21.hours.ago
        create :analytics_event, assessment_code: "CODE4", page: "applicant", browser_id: "BROWSER2", created_at: 20.hours.ago
        create :analytics_event, assessment_code: "CODE4", page: "view_results", browser_id: "BROWSER2", created_at: 16.hours.ago

        # Completed controlled assessment
        create :analytics_event, assessment_code: "CODE5", page: "level_of_help", created_at: 28.hours.ago
        create :analytics_event, assessment_code: "CODE5", event_type: "controlled_level_of_help_chosen", page: "level_of_help_choice", created_at: 27.hours.ago
        create :analytics_event, assessment_code: "CODE5", page: "applicant", created_at: 24.hours.ago
        create :analytics_event, assessment_code: "CODE5", page: "view_results", created_at: 24.hours.ago

        create :analytics_event, page: "index_start"

        create_list :completed_user_journey, 3, certificated: false, outcome: "eligible", form_downloaded: false, completed: 1.day.ago
        create_list :completed_user_journey, 6, certificated: false, outcome: "ineligible", form_downloaded: false, completed: 1.day.ago
        create_list :completed_user_journey, 2, certificated: false, outcome: "eligible", form_downloaded: true, completed: 1.day.ago
      end

      it "pushes appropriate numbers to Geckoboard" do
        expect(all_metric_dataset).to receive(:put).with(
          [
            {
              median_completion_time_controlled: 300.0,
              median_completion_time_certificated: 1500.0,
              certificated_checks_completed: 2,
              checks_completed: 4,
              checks_started: 5,
              completed_checks_per_user: 2,
              completion_rate: 80,
              controlled_checks_completed: 2,
              date: Date.current,
              forms_downloaded: 2,
              forms_percentage: 40,
            },
          ],
        )
        expect(metric_dataset).to receive(:put).with(
          [
            {
              median_completion_time_controlled: nil,
              median_completion_time_certificated: 2880.0,
              certificated_checks_completed: 1,
              checks_completed: 1,
              checks_started: 1,
              completed_checks_per_user: 1,
              completion_rate: 100,
              controlled_checks_completed: 0,
              date: Date.new(2023, 6, 1),
              forms_downloaded: 0,
              forms_percentage: nil,
            },
            {
              median_completion_time_certificated: 120.0,
              median_completion_time_controlled: 300.0,
              certificated_checks_completed: 1,
              checks_completed: 3,
              checks_started: 4,
              completed_checks_per_user: 2,
              completion_rate: 75,
              controlled_checks_completed: 2,
              date: Date.new(2023, 7, 1),
              forms_downloaded: 2,
              forms_percentage: 40,
            },
          ],
        )
        expect(validation_dataset).to receive(:put).with(
          [
            {
              checks: 1,
              screen: "client-outgoings",
              data_type: :current_month,
            },
            {
              checks: 1,
              screen: "vehicle-ownership",
              data_type: :current_month,
            },
            {
              checks: 2,
              screen: "vehicle-ownership",
              data_type: :all_time,
            },
            {
              checks: 1,
              screen: "client-outgoings",
              data_type: :all_time,
            },
          ],
        )
        expect(last_page_dataset).to receive(:put).with(
          [
            { checks: 1, context: "controlled_all_time", screen: "vehicle-ownership" },
            { checks: 1, context: "controlled_current_month", screen: "vehicle-ownership" },
          ],
        )
        described_class.call
      end
    end
  end
end
