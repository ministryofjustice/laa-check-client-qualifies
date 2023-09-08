require "rails_helper"

RSpec.describe "provider_users", type: :feature do
  describe "radio buttons" do
    before do
      visit "/do-you-give-legal-advice-or-provide-legal-services"
    end

    it "errors when nothing is entered" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content("Select yes if you give legal advice or provide legal services")
      end
    end
  end
end
