require "rails_helper"

RSpec.describe "Employment Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:employment_header) { "Add your client's salary breakdown" }
  let(:housing_benefit_header) { "Does your client receive Housing Benefit?" }

  describe "functionality" do
    before do
      driven_by(:headless_chrome)
      travel_to arbitrary_fixed_time

      visit_applicant_page
      fill_in_applicant_screen_without_passporting_benefits
      select_applicant_boolean(:employed, true)
      select_applicant_boolean(:dependants, false)
      click_on "Save and continue"
    end

    it "shows the correct page" do
      expect(page).to have_content employment_header
    end

    it "allows me to fill in the form and move on" do
      fill_in "employment-form-gross-income-field", with: 1000
      fill_in "employment-form-income-tax-field", with: 100
      fill_in "employment-form-national-insurance-field", with: 50
      select_radio_value("employment-form", "frequency", "week")
      click_on "Save and continue"
      expect(page).to have_content(housing_benefit_header)
      select_boolean_value("housing-benefit-form", :housing_benefit, false)
      click_on "Save and continue"
      select_boolean_value("benefits-form", :add_benefit, false)
      click_on "Save and continue"
      complete_incomes_screen
      progress_to_submit_from_outgoings
    end
  end
end
