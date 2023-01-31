require "rails_helper"

RSpec.describe "Level of help page" do
  let(:level_of_help_header) { I18n.t("estimate_flow.level_of_help.title") }

  context "when controlled is not enabled" do
    it "does not show this page" do
      visit_first_page
      expect(page).not_to have_content level_of_help_header
    end
  end

  context "when controlled is enabled", :controlled_flag do
    it "shows this page first" do
      visit_first_page
      expect(page).to have_content level_of_help_header
    end

    it "shows an error if nothing is selected" do
      visit_first_page
      click_on "Save and continue"
      expect(page).to have_content level_of_help_header
      expect(page).to have_content "Select the level of help your client needs"
    end
  end
end
