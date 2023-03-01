require "rails_helper"

RSpec.describe "Check answers page" do
  let(:benefits_subsection_header) { I18n.t("estimates.check_answers.benefits") }

  before do
    stub_request(:get, "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/state_benefit_type").to_return(
      status: 200,
      body: [{ "label" => "child_benefit", "name" => "Child Benefit", "exclude_from_gross_income" => false }],
    )
  end

  context "when I have entered benefits" do
    before do
      visit_check_answers(passporting: false) do |step|
        case step
        when :benefits
          select_boolean_value("benefits-form", :add_benefit, true)
          click_on "Save and continue"
          fill_in "Benefit name", with: "Child benefit"
          fill_in "Enter amount", with: "150"
          choose "Every week"
          click_on "Save and continue"
          select_boolean_value("benefits-form", :add_benefit, false)
        end
      end
    end

    scenario "I can modify those benefits from the 'check answers' screen" do
      within("#subsection-benefits-header") { click_on "Change" }
      click_on "Change"
      fill_in "Benefit name", with: "Child Benefits"
      click_on "Save and continue"
      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"
      within("#field-list-benefits") do
        expect(page).to have_content "Child Benefits"
      end
    end

    scenario "I can add more benefits from the 'check answers' screen" do
      within("#subsection-benefits-header") { click_on "Change" }

      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit name", with: "Universal credit"
      fill_in "Enter amount", with: "300"
      choose "Every week"
      click_on "Save and continue"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      within("#field-list-benefits") do
        expect(page).to have_content "Child benefit"
        expect(page).to have_content "Universal credit"
      end
    end

    scenario "I can remove benefits from the 'check answers' screen" do
      within("#subsection-benefits-header") { click_on "Change" }

      click_on "Remove"

      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"

      within("#field-list-benefits") do
        expect(page).not_to have_content "Child benefit"
      end
    end
  end

  context "when I have no benefits so far and no passporting benefit" do
    before do
      visit_check_answers(passporting: false)
    end

    scenario "I can create new benefits from the 'check answers' screen" do
      expect(page).to have_content benefits_subsection_header
      within("#subsection-benefits-header") { click_on "Change" }
      select_boolean_value("benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit name", with: "Child Benefits"
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
      visit_check_answers(passporting: true)
    end

    scenario "I should not see a benefits section" do
      expect(page).not_to have_content benefits_subsection_header
    end
  end

  context "when I have a partner", :partner_flag do
    before do
      visit_check_answer_with_partner
    end

    scenario "I should see partner content" do
      expect(page).to have_content "Partner's employment"
      expect(page).to have_content "Partner's other income"
      expect(page).to have_content "Partner's outgoings"
      expect(page).to have_content "Partner's assets"
      within("#subsection-partner_benefits-header") { click_on "Change" }
      select_boolean_value("partner-benefits-form", :add_benefit, false)
      click_on "Save and continue"
      expect(page).to have_content "Check your answers"
    end
  end
end
