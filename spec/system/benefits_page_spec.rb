require "rails_helper"

RSpec.describe "Benefits Page", :vcr do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }
  let(:property_header) { "Your client's property" }
  let(:vehicle_header) { "Does your client own a vehicle?" }
  let(:income_header) { "What other income does your client receive?" }

  before do
    driven_by(:rack_test)
    travel_to arbitrary_fixed_time

    visit_applicant_page
    select_applicant_boolean(:over_60, false)
    select_applicant_boolean(:dependants, false)
    select_applicant_boolean(:partner, false)
    select_applicant_boolean(:employed, false)
    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"

    select_boolean_value("benefit-yesno-form", :has_benefits, true)
    click_on "Save and continue"
  end

  it "handles benefits" do
    fill_in "benefit-details-form-benefit-type-field", with: "Coconut Benefit"
    fill_in "benefit-details-form-benefit-amount-field", with: "98.04"
    click_checkbox "benefit-details-form", "benefit-frequency-1"
    click_on "Save and continue"

    expect(page).to have_content "You have added 1 benefits"
    select_boolean_value("benefit-more-form", :more_benefits, false)
    click_on "Save and continue"
    expect(page).to have_content income_header
  end
end
