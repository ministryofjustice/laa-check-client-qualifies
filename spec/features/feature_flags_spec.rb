require "rails_helper"

RSpec.describe "Feature flags" do
  around do |example|
    ENV["FEATURE_FLAGS_PASSWORD"] = "password"
    example.run
    ENV["FEATURE_FLAGS_PASSWORD"] = nil
  end

  context "when in readonly mode" do
    before do
      allow(FeatureFlags).to receive(:static).and_return(%i[static_flag])
      allow(FeatureFlags).to receive(:time_dependant).and_return(%i[time_dependant_flag])
      allow(FeatureFlags).to receive(:enabled?).and_return(false)
      allow(FeatureFlags).to receive(:enabled?).with(:static_flag, without_session_data: true).and_return(true)
      allow(FeatureFlags).to receive(:enabled?).with(:time_dependant_flag, without_session_data: true).and_return(false)
    end

    scenario "I see all public feature flags" do
      visit feature_flags_path
      expect(page).to have_content "static_flagYes"
      expect(page).to have_content "time_dependant_flagNo"
    end
  end

  context "when overriding feature flags is permitted" do
    around do |example|
      ENV["FEATURE_FLAG_OVERRIDES"] = "enabled"
      example.run
      ENV["FEATURE_FLAG_OVERRIDES"] = nil
    end

    scenario "I see link to edit a feature flag" do
      visit feature_flags_path
      expect(page).to have_content "Override"
    end
  end

  context "when setting feature flags in the session" do
    around do |example|
      ENV["EXAMPLE_FEATURE_FLAG"] = "enabled"
      example.run
      ENV["EXAMPLE_FEATURE_FLAG"] = "disabled"
    end

    scenario "I have session feature flags set in the session" do
      visit "estimates/new"
      expect(session_contents["feature_flags"]).to include({ "example" => true })
      expect(session_contents["feature_flags"]).not_to include({ "sentry" => false })
    end
  end
end
