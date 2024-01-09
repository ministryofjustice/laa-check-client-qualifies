require "rails_helper"

RSpec.describe "client_age", type: :feature do
  let(:title) { I18n.t("question_flow.client_age.title") }
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "feature_flags" => FeatureFlags.session_flags)
    visit form_path(:client_age, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content title
    expect(page).to have_content "Select the age group your client is in"
  end

  it "stores the chosen value in the session" do
    choose "Under 18"
    click_on "Save and continue"
    expect(session_contents["client_age"]).to eq "under_18"
  end
end
