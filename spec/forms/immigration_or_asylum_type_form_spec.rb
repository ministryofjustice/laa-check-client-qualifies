require "rails_helper"

RSpec.describe "immigration_or_asylum_type", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit "estimates/#{assessment_code}/build_estimates/immigration_or_asylum_type"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select what type of immigration or asylum matter this is"
  end

  it "stores the chosen value in the session" do
    choose "Asylum"
    click_on "Save and continue"
    expect(session_contents["immigration_or_asylum_type"]).to eq "asylum"
  end
end
