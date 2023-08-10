require "rails_helper"

RSpec.describe "Maintenance mode page", type: :feature do
  context "when the flag is turned on", :maintenance_mode_flag do
    scenario "I can view the help page" do
      visit root_path
      expect(page).to have_text "GOV.UK\nCheck if your client qualifies for legal aid\nThere is a problem with the service Skip to main content\nSorry, there is a problem with the service\n"
    end
  end
end
