require "rails_helper"

RSpec.describe "housing_benefit", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit "estimates/#{assessment_code}/build_estimates/housing_benefit"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["housing_benefit"]).to eq true
  end
end
