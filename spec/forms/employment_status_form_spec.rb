require "rails_helper"

RSpec.describe "employment status form", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit "estimates/#{assessment_code}/build_estimates/employment_status"
  end

  context "when the household section flag is enabled", :household_section_flag do
    it "shows appropriate error messages if form blank" do
      click_on "Save and continue"
      within ".govuk-error-summary__list" do
        expect(page.text).to eq("Select an employment status")
      end
    end

    it "stores the employed value in the session" do
      choose "Employed or self-employed", name: "employment_status_form[employment_status]"
      click_on "Save and continue"

      expect(session_contents["employment_status"]).to eq "in_work"
    end

    it "stores the unemployed value in the session" do
      choose "Unemployed", name: "employment_status_form[employment_status]"
      click_on "Save and continue"

      expect(session_contents["employment_status"]).to eq "unemployed"
    end

    context "when level of help is controlled" do
      let(:level_of_help) { "controlled" }
      let(:hint_text) { "Including if your client is paid in cash, is a sole trader, is a company director, is in a partnership, or gets Statutory Sick Pay or Statutory Maternity Pay" }

      it "shows correct hint text for employed" do
        expect(page).to have_content(hint_text)
      end
    end

    context "when level of help is certificated" do
      let(:level_of_help) { "certificated" }
      let(:hint_text) { "Including if your client is paid in cash, is a sole trader, is in a partnership, or gets Statutory Sick Pay or Statutory Maternity Pay" }

      it "shows correct hint text for employed" do
        expect(page).to have_content(hint_text)
      end
    end
  end
end
