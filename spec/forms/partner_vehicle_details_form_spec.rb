require "rails_helper"

RSpec.describe "partner_vehicle_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/partner_vehicle_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "partner-vehicle-details-form-vehicle-value-field", with: "5000"
    choose "Yes", name: "partner_vehicle_details_form[vehicle_in_regular_use]"
    choose "No", name: "partner_vehicle_details_form[vehicle_over_3_years_ago]"
    choose "Yes", name: "partner_vehicle_details_form[vehicle_pcp]"
    fill_in "partner-vehicle-details-form-vehicle-finance-field", with: "2000"
    click_on "Save and continue"

    expect(session_contents["partner_vehicle_value"]).to eq 5_000
    expect(session_contents["partner_vehicle_finance"]).to eq 2_000
    expect(session_contents["partner_vehicle_in_regular_use"]).to eq true
    expect(session_contents["partner_vehicle_over_3_years_ago"]).to eq false
    expect(session_contents["partner_vehicle_pcp"]).to eq true
  end
end
