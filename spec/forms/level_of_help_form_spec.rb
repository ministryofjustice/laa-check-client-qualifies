require "rails_helper"

RSpec.describe "level_of_help", type: :feature do
  let(:level_of_help_header) { I18n.t("estimate_flow.level_of_help.title") }
  let(:assessment_code) { "assessment-code" }

  before do
    set_session(assessment_code, {})
    visit "estimates/#{assessment_code}/build_estimates/level_of_help"
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content level_of_help_header
    expect(page).to have_content "Select the level of help your client needs"
  end

  it "stores the chosen value in the session" do
    choose "Civil certificated or licensed legal work"
    click_on "Save and continue"
    expect(session_contents["level_of_help"]).to eq "certificated"
  end

  it "stores the choice as an analytics event" do
    choose "Civil certificated or licensed legal work"
    click_on "Save and continue"
    expect(AnalyticsEvent.find_by(assessment_code:, page: "level_of_help_choice").event_type).to eq "certificated_level_of_help_chosen"
  end
end
