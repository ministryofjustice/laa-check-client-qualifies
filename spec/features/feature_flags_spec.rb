require "rails_helper"

RSpec.describe "Feature flags" do
  before do
    allow(FeatureFlags).to receive(:static).and_return(%i[static_flag])
    allow(FeatureFlags).to receive(:time_dependant).and_return(%i[time_dependant_flag])
    allow(FeatureFlags).to receive(:enabled?).with(:static_flag).and_return(true)
    allow(FeatureFlags).to receive(:enabled?).with(:time_dependant_flag).and_return(false)
  end

  scenario "I see all public feature flags" do
    visit feature_flags_path
    expect(page).to have_content "static_flag Yes"
    expect(page).to have_content "time_dependant_flag No"
  end
end
