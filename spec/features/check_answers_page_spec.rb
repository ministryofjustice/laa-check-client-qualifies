require "rails_helper"

RSpec.describe "Check answers page" do
  let(:estimate_id) { SecureRandom.uuid }

  context "when I have entered benefits" do
    before do
      visit estimate_build_estimate_path(estimate_id, :benefits)
      find(:css, "#benefits-form-add-benefit-true-field").click
      click_on "Save and continue"
      fill_in "Benefit type", with: "Child benefit"
      fill_in "Enter amount", with: "150"
      choose "Every week"
      click_on "Save and continue"
    end

    scenario "I can modify those benefits from the 'check answers' screen" do
      visit estimate_build_estimate_path(estimate_id, :check_answers)

      within("#field-list-benefits") { click_on "Change" }
      fill_in "Benefit type", with: "Child Benefits"
      click_on "Save and continue"
      within("#field-list-benefits") do
        expect(page).to have_content "Child Benefits"
      end
    end
  end
end
