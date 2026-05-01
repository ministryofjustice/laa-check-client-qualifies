require "rails_helper"

RSpec.describe JourneyLoggerService do
  describe ".call" do
    it "returns nil" do
      expect(described_class.call(anything, anything, anything, anything)).to be_nil
    end

    it "doesn't call build_attributes" do
      expect(described_class).not_to receive(:build_attributes)

      expect(described_class.call(anything, anything, anything, anything)).to be_nil
    end

    it "doesn't open CompletedUserJourney transaction" do
      expect(CompletedUserJourney).not_to receive(:transaction)

      expect(described_class.call(anything, anything, anything, anything)).to be_nil
    end
  end
end
