require "rails_helper"

RSpec.describe "Maintenance mode page", type: :feature do
  context "when the flag is turned on", :maintenance_mode_flag do
    scenario "I can view the help page" do
      visit root_path
      expect(page).to have_text "Skip to main content\nGOV.UK\nCheck if your client qualifies for legal aid\nSorry, there is a problem with the service\nTry again later.\nWe have not saved your answers.\nUse our means assessment resources for guidance on checking a client's eligibility.\nContact our customer services team for support with legal aid administration or training:\ntelephone: 0300 200 2020 webchat on our training website\nAll content is available under the Open Government Licence v3.0, except where otherwise stated\n© Crown copyright"
    end
  end

  context "when the flag is turned off" do
    scenario "I can view the start page page" do
      visit root_path
      expect(page).to have_text "Use this service to find out if your client is likely to get civil legal aid, based on their financial situation."
    end
  end
end
