require "rails_helper"

RSpec.describe "Assets Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:assets_header) { "Which assets does your client have?" }

  before do
    travel_to arbitrary_fixed_time
    visit "/estimates/new"

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
  end

  it "shows the correct page" do
    expect(page).to have_content assets_header
  end

  it "sets error on assets form" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please select at least one option")
    end
  end

  it "can submit non-zero savings and investments" do
    click_checkbox("assets-form-assets", "savings")
    fill_in "assets-form-savings-field", with: "100"

    click_checkbox("assets-form-assets", "investments")
    fill_in "assets-form-investments-field", with: "500"

    click_on "Save and continue"

    expect(page).to have_content "Summary Page"
  end

  it "can fill in the assets questions and get to results" do
    click_checkbox("assets-form-assets", "none")
    click_on "Save and continue"

    expect(page).to have_content "Summary Page"
    click_on "Submit"

    expect(page).to have_content "Results Page"
  end
end
