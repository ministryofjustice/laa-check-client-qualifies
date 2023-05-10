require "rails_helper"

RSpec.describe "partner_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:intro_paragraph) { "We will now ask for some details about your client's partner to help us get an accurate financial picture of them." }
  let(:employment_question) { "What is the partner's employment status?" }
  let(:session) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/partner_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "has some long-form copy and questions about employment" do
    expect(page).to have_content intro_paragraph
    expect(page).to have_content employment_question
  end

  it "stores my responses in the session" do
    choose "Yes", name: "partner_details_form[over_60]"
    choose "Employed and in work", name: "partner_details_form[employment_status]"
    click_on "Save and continue"

    expect(session_contents["partner_over_60"]).to eq true
    expect(session_contents["partner_employment_status"]).to eq "in_work"
  end

  context "when the client gets a passporting benefit" do
    let(:session) { { "level_of_help" => "controlled", "passporting" => true } }

    it "does not ask about employment" do
      expect(page).not_to have_content employment_question
    end
  end

  context "when the household flow is switched on", :household_section_flag do
    it "does not show the intro paragraph" do
      expect(page).not_to have_content intro_paragraph
    end
  end
end
