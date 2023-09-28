require "rails_helper"

RSpec.describe "immigration_or_asylum_type_upper_tribunal", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit form_path(:immigration_or_asylum_type_upper_tribunal, assessment_code)
  end

  it "shows an error message if a radio button is not selected" do
    click_on "Save and continue"
    expect(page).to have_content "Select what type of immigration or asylum matter this is"
  end

  it "stores the chosen value in the session" do
    choose "Yes, asylum (Upper Tribunal)"
    click_on "Save and continue"
    expect(session_contents["immigration_or_asylum_type_upper_tribunal"]).to eq "asylum_upper"
  end
end
