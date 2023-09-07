require "rails_helper"

RSpec.describe "partner_additional_property", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, { "level_of_help" => "controlled" })
    visit form_path(:partner_additional_property, assessment_code)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes, owned outright"
    click_on "Save and continue"

    expect(session_contents["partner_additional_property_owned"]).to eq "outright"
  end
end
