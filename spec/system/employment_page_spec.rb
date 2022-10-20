require "rails_helper"

RSpec.describe "Employment Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:employment_header) { "Add your client's salary breakdown" }
  let(:income_header) { "What other income does your client receive?" }

  describe "functionality" do
    before do
      driven_by(:rack_test)
      travel_to arbitrary_fixed_time

      visit_applicant_page
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:employed, true)
      select_applicant_boolean(:passporting, false)
      click_on "Save and continue"
    end

    it "shows the correct page" do
      expect(page).to have_content employment_header
    end

    it "allows me to fill in the form and move on" do
      fill_in "employment-form-gross-income-field", with: 1000
      fill_in "employment-form-income-tax-field", with: 100
      fill_in "employment-form-national-insurance-field", with: 50
      select "Every week", from: "employment-form-frequency-field"
      click_on "Save and continue"
      expect(page).to have_content(income_header)
    end
  end

  describe "accessibility" do
    before do
      travel_to arbitrary_fixed_time

      visit_applicant_page
      select_applicant_boolean(:over_60, false)
      select_applicant_boolean(:dependants, false)
      select_applicant_boolean(:employed, true)
      select_applicant_boolean(:passporting, false)
      click_on "Save and continue"
    end

    it "has no accessibility issues" do
      expect(page).to be_axe_clean
    end
  end
end
