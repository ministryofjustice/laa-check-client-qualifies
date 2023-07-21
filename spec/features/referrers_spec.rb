require "rails_helper"

RSpec.describe "Referrers:" do
  scenario "Referring urls are tracked" do
    visit "/?ref=old-calculator&foo=bar"
    expect(page).to have_current_path "/?foo=bar"
    expect(AnalyticsEvent.find_by(event_type: "referral").page).to eq "old-calculator"
  end
end
