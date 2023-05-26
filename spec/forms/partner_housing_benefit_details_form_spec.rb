require "rails_helper"

RSpec.describe "partner_housing_benefit_details", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, {})
    visit "estimates/#{assessment_code}/build_estimates/partner_housing_benefit_details"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "saves what I enter to the session" do
    fill_in "partner_housing_benefit_details_form[housing_benefit_value]", with: "10"
    choose "Every 4 weeks"
    click_on "Save and continue"
    expect(session_contents["partner_housing_benefit_value"]).to eq 10
    expect(session_contents["partner_housing_benefit_frequency"]).to eq "every_four_weeks"
  end
end
