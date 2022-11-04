require "rails_helper"

RSpec.describe "Vehicle Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:check_answers_header) { "Check your answers" }
  let(:assets_header) { "Which of these assets does your client have?" }

  before do
    travel_to arbitrary_fixed_time
  end

  describe "CFE submission" do
    before do
      driven_by(:rack_test)
      visit_vehicle_form
      visit_details_form
    end

    it "handles a full submit to CFE" do
      fill_in "vehicle-details-form-vehicle-value-field", with: 18_000
      select_boolean_value("vehicle-details-form", :vehicle_in_regular_use, true)
      select_boolean_value("vehicle-details-form", :vehicle_over_3_years_ago, false)
      select_boolean_value("vehicle-details-form", :vehicle_pcp, true)
      fill_in "vehicle-details-form-vehicle-finance-field", with: 500
      click_on "Save and continue"

      expect(page).to have_content assets_header
      skip_assets_form

      expect(page).to have_content check_answers_header
      click_on "Submit"

      expect(page).to have_content "Your client appears provisionally eligible"
    end
  end

  def visit_vehicle_form
    visit_applicant_page
    fill_in_applicant_screen_with_passporting_benefits
    click_on "Save and continue"

    select_radio_value("property-form", "property-owned", "none")
    click_on "Save and continue"
  end

  def visit_details_form
    select_boolean_value("vehicle-form", :vehicle_owned, true)
    click_on "Save and continue"
  end
end
