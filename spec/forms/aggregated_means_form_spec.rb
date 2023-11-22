require "rails_helper"

RSpec.describe "aggregated_means", :under_eighteen_flag, type: :feature do
  let(:title) { I18n.t("question_flow.aggregated_means.title") }
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "feature_flags" => FeatureFlags.session_flags)
    visit form_path(:aggregated_means, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content title
    expect(page).to have_content "Select yes if you will aggregate your client’s means with another person’s means"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["aggregated_means"]).to eq true
  end
end
