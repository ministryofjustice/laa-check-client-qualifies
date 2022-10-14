require "rails_helper"

RSpec.describe "Assets Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:applicant_header) { "About your client" }

  before do
    travel_to arbitrary_fixed_time
  end

  # have to skip aria-allowed-attr for govuk conditional radio buttons.
  it "has no AXE-detectable accessibility issues" do
    visit_applicant_page
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)
    select_applicant_boolean(:passporting, true)
    click_on "Save and continue"

    click_checkbox("property-form-property-owned", "none")
    click_on "Save and continue"

    select_boolean_value("vehicle-form", :vehicle_owned, false)
    click_on "Save and continue"

    expect(page).to be_axe_clean.skipping("aria-allowed-attr")

    click_checkbox("assets-form-assets", "property")
    fill_in "assets-form-property-value-field", with: "80_000"
    fill_in "assets-form-property-mortgage-field", with: "40_000"
    fill_in "assets-form-property-percentage-owned-field", with: "50"

    click_checkbox("assets-form-assets", "savings")
    fill_in "assets-form-savings-field", with: "100"

    click_checkbox("assets-form-assets", "investments")
    fill_in "assets-form-investments-field", with: "500"

    click_on "Save and continue"

    expect(page).to have_content "Summary Page"
    click_on "Submit"
    expect(page).to have_content "Your client appears ineligible for legal aid"
  end
end
