require "rails_helper"

RSpec.describe "vehicle", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/vehicle"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes"
    click_on "Save and continue"

    expect(session_contents["vehicle_owned"]).to eq true
  end
end
