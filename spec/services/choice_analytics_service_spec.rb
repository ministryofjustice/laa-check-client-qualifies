require "rails_helper"

RSpec.describe ChoiceAnalyticsService do
  describe ".call" do
    let(:form) { LevelOfHelpForm.new }

    it "handles errors without crashing" do
      expect(ErrorService).to receive(:call)
      allow(AnalyticsEvent).to receive(:create!).and_raise "Error!"
      expect { described_class.call(form, "assessment_code", nil) }.not_to raise_error
    end
  end
end
