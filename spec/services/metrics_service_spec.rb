require "rails_helper"

RSpec.describe MetricsService do
  describe ".call" do
    context "when api key is not set" do
      it "does nothing" do
        expect(Metrics::ForKeyMetricDashboardService).not_to receive(:call)
        described_class.call
      end
    end

    context "when api key is set" do
      around do |example|
        ENV["GECKOBOARD_ENABLED"] = "enabled"
        example.run
        ENV["GECKOBOARD_ENABLED"] = nil
      end

      it "calls its sub-components" do
        expect(Metrics::ForKeyMetricDashboardService).to receive(:call)
        expect(Metrics::ForUserJourneyDashboardService).to receive(:call)
        described_class.call
      end
    end
  end
end
