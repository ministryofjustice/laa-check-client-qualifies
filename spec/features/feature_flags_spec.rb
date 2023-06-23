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
      allow(FeatureFlags).to receive(:enabled?).with(:static_flag).and_return(true)
      allow(FeatureFlags).to receive(:enabled?).with(:time_dependant_flag).and_return(false)
    end

    scenario "I see all public feature flags" do
      visit feature_flags_path
      expect(page).to have_content "static_flagYes"
      expect(page).to have_content "time_dependant_flagNo"
    end

    scenario "I cannot view the form to edit feature flags" do
      page.driver.browser.basic_authorize("flags", "password")
      visit edit_feature_flag_path("sentry")
      expect(page).to have_current_path "/"
    end
  end

  context "when overriding feature flags is permitted" do
    around do |example|
      ENV["FEATURE_FLAG_OVERRIDES"] = "enabled"
      example.run
      ENV["FEATURE_FLAG_OVERRIDES"] = nil
    end

    scenario "I can't access the edit screen without a password" do
      visit edit_feature_flag_path("sentry")
      expect(page).to have_content "HTTP Basic: Access denied."
    end

    scenario "I edit a feature flag" do
      page.driver.browser.basic_authorize("flags", "password")
      visit feature_flags_path
      expect(page).to have_content "sentryNo"
      expect(FeatureFlags.enabled?(:sentry)).to eq false

      visit edit_feature_flag_path("sentry")
      choose "Yes"
      click_on "Save and continue"
      expect(page).to have_content "sentryYes"
      expect(FeatureFlags.enabled?(:sentry)).to eq true

      visit edit_feature_flag_path("sentry")
      choose "No"
      click_on "Save and continue"
      expect(page).to have_content "sentryNo"
      expect(FeatureFlags.enabled?(:sentry)).to eq false
    end
  end
end
