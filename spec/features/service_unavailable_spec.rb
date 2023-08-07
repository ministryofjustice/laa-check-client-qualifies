require "rails_helper"

RSpec.describe "Service unavailable" do
  context "when the feature flag is turned on", :maintenance_mode do
    it "renders the contnet on the page" do
      visit "/500"
      expect(page).to have_content "Sorry"
    end
  end
end
