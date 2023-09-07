require "rails_helper"

RSpec.describe "partner employment status form", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help, "partner" => true)
    visit form_path(:partner_employment_status, assessment_code)
  end

  it "shows appropriate error messages if form blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq("Select an employment status")
    end
  end

  it "stores the employed value in the session" do
    choose "Employed or self-employed"
    click_on "Save and continue"

    expect(session_contents["partner_employment_status"]).to eq "in_work"
  end

  context "when level of help is controlled" do
    let(:level_of_help) { "controlled" }
    let(:hint_text) { "Including if the partner is paid in cash, is a sole trader, is a company director, is in a partnership, or gets Statutory Sick Pay or Statutory Maternity Pay" }

    it "shows correct hint text for employed" do
      expect(page).to have_content(hint_text)
    end
  end

  context "when level of help is certificated" do
    let(:level_of_help) { "certificated" }
    let(:hint_text) { "Including if the partner is paid in cash, is a sole trader, is in a partnership, or gets Statutory Sick Pay or Statutory Maternity Pay" }

    it "shows correct hint text for employed" do
      expect(page).to have_content(hint_text)
    end
  end
end
