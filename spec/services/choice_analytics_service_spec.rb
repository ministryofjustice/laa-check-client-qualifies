require "rails_helper"

RSpec.describe ChoiceAnalyticsService do
  describe ".call" do
    let(:form) { LevelOfHelpForm.new }
    let(:assessment_code) { "assessment_code" }

    it "handles errors without crashing" do
      expect(ErrorService).to receive(:call)
      allow(AnalyticsEvent).to receive(:create!).and_raise "Error!"
      expect { described_class.call(form, assessment_code, {}) }.not_to raise_error
    end

    it "respects no-analytics mode" do
      cookies = { CookiesController::NO_ANALYTICS_MODE => "true" }
      described_class.call(form, assessment_code, cookies)
      expect(AnalyticsEvent.count).to eq 0
    end
  end
end
