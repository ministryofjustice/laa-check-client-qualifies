require "rails_helper"

RSpec.describe "asylum_support", type: :feature do
  let(:asylum_support_header) { I18n.t("question_flow.asylum_support.question") }
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit form_path(:asylum_support, assessment_code)
  end

  it "shows an error message if no value is entered" do
    click_on "Save and continue"
    expect(page).to have_content asylum_support_header
    expect(page).to have_content "Select if your client receives section 4 or section 95 Asylum Support"
  end

  it "stores the chosen value in the session" do
    choose "Yes"
    click_on "Save and continue"
    expect(session_contents["asylum_support"]).to eq true
  end

  it "has no extra piece of guidance" do
    expect(page).not_to have_content "Guide to determining controlled work"
  end

  context "when in a controlled work context" do
    let(:level_of_help) { "controlled" }

    it "has an extra piece of guidance" do
      expect(page).to have_content "Guide to determining controlled work"
    end
  end
end
