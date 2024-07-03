require "rails_helper"

RSpec.describe "vehicle", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, {})
    visit form_path(:vehicle, assessment_code)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes"
    click_on "Save and continue"

    expect(session_contents["vehicle_owned"]).to be true
  end
end
