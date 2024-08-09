require "rails_helper"

RSpec.describe "employment status form", :might_call_cfe, type: :feature do
  let(:level_of_help) { :certificated }

  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(level_of_help)
    fill_in_forms_until(:employment_status)
  end

  it "shows appropriate error messages if form blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq("Select an employment status")
    end
  end

  context "with check_answers" do
    let(:employment_text) { "Client employment income" }

    context "when employed" do
      before do
        choose "Employed or self-employed", name: "employment_status_form[employment_status]"
        click_on "Save and continue"
      end

      it "stores the employed value in the session" do
        expect(session_contents["employment_status"]).to eq "in_work"
      end

      it "shows check answers" do
        fill_in_forms_until(:check_answers)
        expect(page).to have_content employment_text
      end
    end

    context "when unemployed" do
      before do
        choose "Unemployed", name: "employment_status_form[employment_status]"
        click_on "Save and continue"
      end

      it "stores the unemployed value in the session" do
        expect(session_contents["employment_status"]).to eq "unemployed"
      end

      it "shows check answers" do
        fill_in_forms_until(:check_answers)
        expect(page).not_to have_content employment_text
      end
    end
  end

  context "when level of help is controlled" do
    let(:level_of_help) { :controlled }
    let(:hint_text) { "Including if your client is paid in cash, is a sole trader, is a company director, is in a partnership, or gets Statutory Sick Pay or Statutory Maternity Pay" }

    it "shows correct hint text for employed" do
      expect(page).to have_content(hint_text)
    end
  end

  context "when level of help is certificated" do
    let(:level_of_help) { :certificated }
    let(:hint_text) { "Including if your client is paid in cash, is a sole trader, is in a partnership, or gets Statutory Sick Pay or Statutory Maternity Pay" }

    it "shows correct hint text for employed" do
      expect(page).to have_content(hint_text)
    end
  end
end
