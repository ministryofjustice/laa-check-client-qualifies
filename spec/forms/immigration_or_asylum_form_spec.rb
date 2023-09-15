require "rails_helper"

RSpec.describe "immigration_or_asylum", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit form_path(:immigration_or_asylum, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select yes if this is an immigration or asylum matter"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["immigration_or_asylum"]).to eq true
  end
end
