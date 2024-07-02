require "rails_helper"

RSpec.describe "partner_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session)
    visit form_path(:partner_details, assessment_code)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes", name: "partner_details_form[over_60]"
    click_on "Save and continue"

    expect(session_contents["partner_over_60"]).to be true
  end
end
