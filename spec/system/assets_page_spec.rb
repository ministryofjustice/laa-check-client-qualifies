require "rails_helper"

RSpec.describe "Assets Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:applicant_header) { "About your client" }
  let(:check_answers_header) { "Check your answers" }

  before do
    travel_to arbitrary_fixed_time
  end

  it "has no AXE-detectable accessibility issues" do
    visit_applicant_page
    fill_in_applicant_screen_with_passporting_benefits
    click_on "Save and continue"

    click_checkbox("property-form-property-owned", "with_mortgage")
    click_on "Save and continue"
    fill_in "property-entry-form-house-value-field", with: 100_000
    fill_in "property-entry-form-mortgage-field", with: 50_000
    fill_in "property-entry-form-percentage-owned-field", with: 100
    click_on "Save and continue"

    select_boolean_value("vehicle-form", :vehicle_owned, false)
    click_on "Save and continue"

    expect(page).to be_axe_clean.skipping("aria-allowed-attr")

    fill_in "assets-form-property-value-field", with: "80_000"
    fill_in "assets-form-property-mortgage-field", with: "40_000"
    fill_in "assets-form-property-percentage-owned-field", with: "50"

    fill_in "assets-form-savings-field", with: "100"
    fill_in "assets-form-investments-field", with: "500"
    fill_in "assets-form-valuables-field", with: "0"

    click_on "Save and continue"

    expect(page).to have_content check_answers_header
    click_on "Submit"
    expect(page).to have_content "Your client appears ineligible for legal aid"
  end
end
