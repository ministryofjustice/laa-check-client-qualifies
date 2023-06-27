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

  describe "global and session flags" do
    let(:session_data) { { "feature_flags" => {} } }

    context "when global flag is switched on do" do
      around do |each|
        ENV["SENTRY_FEATURE_FLAG"] = "enabled"
        each.run
        ENV["SENTRY_FEATURE_FLAG"] = "disabled"
      end

      it "defaults to global flag when the flag does not exist in the session_data" do
        expect(described_class.enabled?(:sentry, session_data)).to eq true
      end

      context "when flag is specified in the session_data" do
        let(:session_data) { { "feature_flags" => { "sentry" => false } } }

        it "returns the value from the session_data" do
          expect(described_class.enabled?(:sentry, session_data)).to eq false
        end
      end
    end
  end

  it "contains no out of date flags" do
    expect(described_class::ENABLED_AFTER_DATE.values.count { 1.month.ago > _1[:from] }).to eq 0
  end

  it "errors on unrecognised flags" do
    expect { described_class.enabled?(:unknown_flag) }.to raise_error "Unrecognised flag 'unknown_flag'"
  end

  describe ".static" do
    it "returns all static flags" do
      expect(described_class.static).to eq FeatureFlags::STATIC_FLAGS.keys
    end
  end

  describe ".time_dependant" do
    it "hides private flags" do
      expect(described_class.time_dependant).not_to include(:example_2125_flag)
    end
  end

  describe ".overrideable?" do
    around do |example|
      ENV["FEATURE_FLAG_OVERRIDES"] = "enabled"
      example.run
      ENV["FEATURE_FLAG_OVERRIDES"] = nil
    end

    it "returns true if the env var is set" do
      expect(described_class.time_dependant).not_to include(:example_2125_flag)
    end
  end
end
