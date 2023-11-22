require "rails_helper"

RSpec.describe "regular_income", :under_eighteen_flag, type: :feature do
  let(:title) { I18n.t("question_flow.regular_income.title") }
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "feature_flags" => FeatureFlags.session_flags)
    visit form_path(:regular_income, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content title
    expect(page).to have_content "Select yes if your client gets regular income"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["regular_income"]).to eq true
  end
end
