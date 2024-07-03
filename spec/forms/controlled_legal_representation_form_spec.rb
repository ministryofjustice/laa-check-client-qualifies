require "rails_helper"

RSpec.describe "under_18_clr", type: :feature do
  let(:title) { I18n.t("question_flow.under_18_clr.title") }
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "controlled" }

  before do
    set_session(assessment_code, "feature_flags" => FeatureFlags.session_flags)
    visit form_path(:under_18_clr, assessment_code)
  end

  it "shows an error message if no selection is made" do
    click_on "Save and continue"
    expect(page).to have_content title
    expect(page).to have_content "Select yes if the work is controlled legal representation (CLR)"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["controlled_legal_representation"]).to be true
  end
end
