require "rails_helper"

RSpec.describe "matter_type", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit "estimates/#{assessment_code}/build_estimates/matter_type"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content "Select what type of matter this is"
  end

  it "stores the chosen value in the session" do
    choose "Another category of law"
    click_on "Save and continue"
    expect(session_contents["matter_type"]).to eq "other"
  end
end
