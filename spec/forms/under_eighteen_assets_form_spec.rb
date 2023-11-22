require "rails_helper"

RSpec.describe "under_eighteen_assets", :under_eighteen_flag, type: :feature do
  let(:title) { I18n.t("question_flow.under_eighteen_assets.title") }
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "feature_flags" => FeatureFlags.session_flags)
    visit form_path(:under_eighteen_assets, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content title
    expect(page).to have_content "Select yes if your client has assets worth £2,500 or more"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["under_eighteen_assets"]).to eq true
  end
end
