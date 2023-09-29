require "rails_helper"

RSpec.describe "domestic_abuse_applicant", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit form_path(:domestic_abuse_applicant, assessment_code)
  end

  it "shows an error message if a radio button is not selected" do
    click_on "Save and continue"
    expect(page).to have_content "Select if your client is an applicant in a domestic abuse case"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["domestic_abuse_applicant"]).to eq true
  end
end
