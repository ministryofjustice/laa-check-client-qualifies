require "rails_helper"

RSpec.describe Check do
  describe "#respond_to?" do
    it "returns true for a defined method" do
      expect(described_class.new.respond_to?(:level_of_help)).to eq true
    end

    it "returns true for an inferred method" do
      expect(described_class.new.respond_to?(:employment_status)).to eq true
    end

    it "returns false for a non-existent method" do
      expect(described_class.new.respond_to?(:nonsense)).to eq false
    end
  end

  describe "missing methods" do
    it "behaves as expected when a truly missing method is called" do
      expect { described_class.new.nonsense }.to raise_error NoMethodError
    end
  end

  describe "#any_smod_assets?" do
    it "returns true if there's a SMOD vehicle" do
      check = described_class.new(
        {
          "vehicle_owned" => true,
          "vehicles" => [
            {
              "vehicle_in_dispute" => true,
            },
          ],
        },
      )
      expect(check.any_smod_assets?).to eq true
    end
  end
end
