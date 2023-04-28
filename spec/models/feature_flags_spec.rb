require "rails_helper"

RSpec.describe FeatureFlags do
  describe "example_2125_flag flag" do
    it "returns false before it comes into effect" do
      travel_to "2124-12-31"
      expect(described_class.enabled?(:example_2125_flag)).to eq false
    end

    it "returns true when it comes into effect" do
      travel_to "2125-01-01"
      expect(described_class.enabled?(:example_2125_flag)).to eq true
    end
  end

  it "contains no out of date flags" do
    expect(described_class::ENABLED_AFTER_DATE.values.count { 1.month.ago > _1[:from] }).to eq 0
  end

  it "errors on unrecognised flags" do
    expect { described_class.enabled?(:unknown_flag) }.to raise_error "Unrecognised flag 'unknown_flag'"
  end

  describe ".static" do
    it "returns all flipper flags" do
      expect(described_class.static).to eq FeatureFlags::FLIPPER_FLAGS
    end
  end

  describe ".time_dependant" do
    it "hides private flags" do
      expect(described_class.time_dependant).not_to include(:example_2125_flag)
    end
  end
end
