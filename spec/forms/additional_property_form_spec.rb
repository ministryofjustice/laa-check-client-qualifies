require "rails_helper"

RSpec.describe "additional_property", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, { "level_of_help" => "controlled" })
    visit form_path(:additional_property, assessment_code)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes, owned outright"
    click_on "Save and continue"

    expect(session_contents["additional_property_owned"]).to eq "outright"
  end

  it "shows the shared ownership option" do
    expect(page).to have_field("Yes, through a shared ownership scheme", type: "radio")
  end
end
