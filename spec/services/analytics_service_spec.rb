require "rails_helper"

RSpec.describe AnalyticsService do
  describe ".call" do
    it "handles errors without crashing", :throws_cfe_error do
      expect(ErrorService).to receive(:call)

      expect { described_class.call(event_type: nil, page: "some_page", assessment_code: nil, cookies: {}) }.not_to raise_error
    end

    it "respects no-analytics mode" do
      cookies = { CookiesController::NO_ANALYTICS_MODE => "true" }
      described_class.call(event_type: nil, page: "some_page", assessment_code: nil, cookies:)
      expect(AnalyticsEvent.count).to eq 0
    end
  end
end
