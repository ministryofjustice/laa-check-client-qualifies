require "rails_helper"

RSpec.describe "Vehicle Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:income_header) { "What income does your client receive?" }

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
  end

  it "has a back link to the property input form" do
    click_link "Back"
    expect(page).to have_content property_header
  end

  it "sets error on vehicle form" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select yes if the client owns a vehicle")
    end
  end
end
