require "rails_helper"

RSpec.describe MetricsService do
  describe ".call" do
    let(:client) { instance_double(Geckoboard::Client, datasets: dataset_client) }
    let(:dataset_client) { instance_double(Geckoboard::DatasetsClient) }
    let(:metric_dataset) { instance_double(Geckoboard::Dataset) }
    let(:validation_dataset) { instance_double(Geckoboard::Dataset) }

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
          when "metrics"
            metric_dataset
          when "validations"
            validation_dataset
          end
        end
      end

      context "when there is no relevant data" do
        it "pushes appropriate numbers to Geckoboard" do
          expect(metric_dataset).to receive(:put).with(
            [
              {
                assessments_completed: 0,
                assessments_per_user: nil,
                assessments_started: 0,
                date: 1.day.ago.to_date,
                percent_completed: nil,
                percent_controlled: nil,
              },
            ],
          )
          expect(validation_dataset).to receive(:put).with([])
          described_class.call
        end
      end

      context "when there is relevant data" do
        before do
          # Completed certificated assessment by user 1
          create :analytics_event, assessment_code: "CODE1", page: "applicant", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE1", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE1", page: "view_results", browser_id: "BROWSER1", created_at: 1.day.ago

          # Completed certificated assessment by user 1
          create :analytics_event, assessment_code: "CODE2", page: "applicant", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE2", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE2", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE2", page: "view_results", browser_id: "BROWSER1", created_at: 1.day.ago

          # Incomplete certificated assessment by user 1
          create :analytics_event, assessment_code: "CODE3", page: "applicant", browser_id: "BROWSER1", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE3", page: "outgoings", browser_id: "BROWSER1", created_at: 1.day.ago, event_type: "validation_message"
          create :analytics_event, assessment_code: "CODE3", page: "vehicle", browser_id: "BROWSER1", created_at: 1.day.ago

          # Completed controlled assessment by user 2
          create :analytics_event, assessment_code: "CODE4", page: "applicant", browser_id: "BROWSER2", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE4", page: "view_results", browser_id: "BROWSER2", created_at: 1.day.ago

          # Completed controlled assessment
          create :analytics_event, assessment_code: "CODE5", page: "applicant", created_at: 1.day.ago
          create :analytics_event, assessment_code: "CODE5", page: "view_results", created_at: 1.day.ago

          create :analytics_event, page: "index_start"
        end

        it "pushes appropriate numbers to Geckoboard" do
          expect(metric_dataset).to receive(:put).with(
            [
              {
                assessments_completed: 4,
                assessments_per_user: 2,
                assessments_started: 5,
                date: 1.day.ago.to_date,
                percent_completed: 80,
                percent_controlled: 50,
              },
            ],
          )
          expect(validation_dataset).to receive(:put).with(
            [
              {
                assessments: 2,
                date: 1.day.ago.to_date,
                screen: "vehicle",
              },
              {
                assessments: 1,
                date: 1.day.ago.to_date,
                screen: "outgoings",
              },
            ],
          )
          described_class.call
        end
      end
    end
  end
end
