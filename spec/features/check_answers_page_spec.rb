require "rails_helper"

RSpec.describe "Check answers page" do
  let(:estimate_id) { SecureRandom.uuid }
  let(:benefits_subsection_header) { I18n.t("estimates.check_answers.benefits") }

  context "when I have entered benefits" do
    before do
      visit estimate_build_estimate_path(estimate_id, :benefits)
      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Child benefit"
      fill_in "Enter amount", with: "150"
      choose "Every week"
      click_on "Save and continue"
      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"
      complete_incomes_screen
      skip_outgoings_form

      skip_property_form
      skip_vehicle_form
      skip_assets_form
    end

    scenario "I can modify those benefits from the 'check answers' screen" do
      within("#field-list-benefits") { click_on "Change" }
      fill_in "Benefit type", with: "Child Benefits"
      click_on "Save and continue"
      within("#field-list-benefits") do
        expect(page).to have_content "Child Benefits"
      end
    end

    scenario "I can add more benefits from the 'check answers' screen" do
      within("#subsection-benefits-header") { click_on "Change" }

      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Universal credit"
      fill_in "Enter amount", with: "300"
      choose "Every week"
      click_on "Save and continue"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      expect(page).to have_current_path(check_answers_estimate_path(estimate_id))

      within("#field-list-benefits") do
        expect(page).to have_content "Child benefit"
        expect(page).to have_content "Universal credit"
      end
    end

    scenario "I can remove benefits from the 'check answers' screen" do
      visit check_answers_estimate_path(estimate_id)

      within("#subsection-benefits-header") { click_on "Change" }

      click_on "Remove"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      expect(page).to have_current_path(check_answers_estimate_path(estimate_id))

      within("#field-list-benefits") do
        expect(page).not_to have_content "Child benefit"
      end
    end
  end

  context "when I have no benefits so far and no passporting benefit" do
    before do
      visit_check_answer_without_passporting_benefit
    end

    scenario "I can create new benefits from the 'check answers' screen" do
      expect(page).to have_content benefits_subsection_header
      within("#subsection-benefits-header") { click_on "Change" }
      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Child Benefits"
      fill_in "Enter amount", with: "150"
      choose "Every week"
      click_on "Save and continue"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      within("#field-list-benefits") do
        expect(page).to have_content "Child Benefits"
      end
    end
  end

  context "when I receive a passporting benefit" do
    before do
      visit_check_answer_with_passporting_benefit
    end

    scenario "I should not see a benefits section" do
      expect(page).not_to have_content benefits_subsection_header
    end
  end

  context "when I have a partner" do
    before do
      visit_check_answer_with_partner
    end

    scenario "I should see partner content" do
      expect(page).to have_content "Partner's Employment"
      expect(page).to have_content "Partner's other income"
      expect(page).to have_content "Partner's benefits"
      expect(page).to have_content "Your client's partner's outgoings"
      expect(page).to have_content "Your client's partner's assets"
      expect(page).to have_content "Client's partner's vehicle"
    end
  end
end
