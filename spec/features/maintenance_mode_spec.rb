require "rails_helper"

RSpec.describe "Maintenance mode page", type: :feature do
  context "when the flag is turned on", :maintenance_mode_flag do
    scenario "I can view the maintenance page" do
      visit root_path
      expect(page).to have_text "Sorry, the service is unavailable"
    end
  end

  context "when the flag is turned off" do
    scenario "I can view the start page" do
      visit root_path
      expect(page).to have_text "This service will ask you questions about your client, then tell you if they are likely to get civil legal aid, based on their financial situation."
    end
  end
end
