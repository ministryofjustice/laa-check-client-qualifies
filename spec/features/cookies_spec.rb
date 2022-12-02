require "rails_helper"

RSpec.describe "Cookies" do
  let(:cookie_banner_text) { "Cookies on Check if your client qualifies for legal aid" }

  context "when cookie choices are not made" do
    scenario "I accept cookies via the banner" do
      visit root_path
      expect(page).to have_content cookie_banner_text
      click_on "Accept additional cookies"
      expect(page).to have_content "You’ve accepted additional cookies"
      click_on "Hide"
      expect(page).not_to have_content "You’ve accepted additional cookies"
    end

    scenario "I reject cookies via the banner" do
      visit root_path
      click_on "Reject additional cookies"
      expect(page).to have_content "You’ve rejected additional cookies"
      click_on "Hide"
      expect(page).not_to have_content "You’ve rejected additional cookies"
    end
  end

  context "when cookie choices are already made" do
    before do
      visit root_path
      click_on "Accept additional cookies"
    end

    scenario "I do not see the banner" do
      visit root_path
      expect(page).not_to have_content cookie_banner_text
    end
  end
end
