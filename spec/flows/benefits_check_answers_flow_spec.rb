require "rails_helper"

RSpec.describe "Modifying benefits from check answers screen", type: :feature do
  context "when I already have benefits added" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(
        instance_double(CfeConnection, state_benefit_types: []),
      )

      start_assessment
      fill_in_forms_until(:benefits)
      fill_in_benefits_screen(choice: "Yes")
      fill_in_add_benefit_screen benefit_type: "Old benefit"
      fill_in_benefits_screen
      fill_in_forms_until(:check_answers)
    end

    it "lets me modify my previous answers" do
      within("#subsection-benefits-header") { click_on "Change" }
      click_on "Change"
      fill_in_edit_benefit_screen benefit_type: "New benefit"
      fill_in_benefits_screen
      within("#field-list-benefits") do
        expect(page).not_to have_content "Old benefit"
        expect(page).to have_content "New benefit"
      end
    end

    it "lets me add to my previous answers" do
      within("#subsection-benefits-header") { click_on "Change" }
      fill_in_benefits_screen(choice: "Yes")
      fill_in_add_benefit_screen benefit_type: "New benefit"
      fill_in_benefits_screen
      within("#field-list-benefits") do
        expect(page).to have_content "Old benefit"
        expect(page).to have_content "New benefit"
      end
    end

    it "lets me remove my previous answers" do
      within("#subsection-benefits-header") { click_on "Change" }
      click_on "Remove"
      fill_in_benefits_screen
      within("#field-list-benefits") do
        expect(page).not_to have_content "Old benefit"
      end
    end
  end

  context "when I do not already have benefits added" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(
        instance_double(CfeConnection, state_benefit_types: []),
      )

      start_assessment
      fill_in_forms_until(:check_answers)
    end

    it "lets me add a new benefit" do
      within("#subsection-benefits-header") { click_on "Change" }
      fill_in_benefits_screen(choice: "Yes")
      fill_in_add_benefit_screen benefit_type: "New benefit"
      fill_in_benefits_screen
      within("#field-list-benefits") do
        expect(page).to have_content "New benefit"
      end
    end
  end

  context "when I have a partner" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(
        instance_double(CfeConnection, state_benefit_types: []),
      )

      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "Yes")
      fill_in_forms_until(:partner_benefits)
      fill_in_partner_benefits_screen(choice: "Yes")
      fill_in_add_partner_benefit_screen(benefit_type: "Old benefit")
      fill_in_partner_benefits_screen
      fill_in_forms_until(:check_answers)
    end

    it "allows me to loop back to the partner benefits screen" do
      within("#subsection-partner_benefits-header") { click_on "Change" }
      fill_in_partner_benefits_screen
      confirm_screen("check_answers")
    end

    it "lets me add a new partner benefit" do
      within("#subsection-partner_benefits-header") { click_on "Change" }
      fill_in_partner_benefits_screen(choice: "Yes")
      fill_in_add_partner_benefit_screen benefit_type: "New benefit"
      fill_in_partner_benefits_screen
      within("#field-list-partner_benefits") do
        expect(page).to have_content "New benefit"
      end
    end

    it "lets me remove a benefit" do
      within("#subsection-partner_benefits-header") { click_on "Change" }
      click_on "Remove"
      fill_in_partner_benefits_screen
      within("#field-list-partner_benefits") do
        expect(page).to have_content "No"
      end
    end

    it "lets me edit a benefit" do
      within("#subsection-partner_benefits-header") { click_on "Change" }
      click_on "Change"
      fill_in_edit_partner_benefit_screen benefit_type: "New benefit"
      fill_in_partner_benefits_screen
      within("#field-list-partner_benefits") do
        expect(page).to have_content "New benefit"
      end
    end
  end
end
