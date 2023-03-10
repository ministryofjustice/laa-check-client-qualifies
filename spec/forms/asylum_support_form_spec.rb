require "rails_helper"

RSpec.describe "asylum_support", type: :feature do
  let(:asylum_support_header) { I18n.t("estimate_flow.asylum_support.question") }
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/asylum_support"
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

  context "when in a controlled work context" do
    before do
      set_session(assessment_code, "level_of_help" => "controlled")
      visit "estimates/#{assessment_code}/build_estimates/asylum_support"
    end

    it "has an extra piece of guidance" do
      expect(page).to have_content "Guide to determining controlled work"
    end
  end
end
