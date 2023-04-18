require "rails_helper"

RSpec.describe "No-analytics mode", type: :feature do
  context "when I have not enabled no-analytics mode" do
    scenario "I visit the home page" do
      visit root_path
      expect(page).not_to have_content "No-analytics mode"
      expect(AnalyticsEvent.count).to eq 1
    end
  end

  scenario "I enable no-analytics mode" do
    visit no_analytics_path
    expect(page).to have_current_path "/"
    expect(page).to have_content "No-analytics mode"
    expect(AnalyticsEvent.count).to eq 0
  end
end
