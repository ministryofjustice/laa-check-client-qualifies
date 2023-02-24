require "rails_helper"

RSpec.describe AnalyticsService do
  describe ".call" do
    it "handles errors without crashing" do
      expect(ErrorService).to receive(:call)

      expect { described_class.call(event_type: nil, page: "some_page", assessment_code: nil, browser_id: nil) }.not_to raise_error
    end
  end
end
