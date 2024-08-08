require "rails_helper"

RSpec.describe "under_18_clr", type: :feature do
  let(:title) { I18n.t("question_flow.under_18_clr.title") }

  before do
    start_assessment
    fill_in_forms_until(:client_age)
    fill_in_client_age_screen(choice: "Under 18")
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(:controlled)
    fill_in_forms_until(:under_18_clr)
  end

  it "shows an error message if no selection is made" do
    click_on "Save and continue"
    expect(page).to have_content title
    expect(page).to have_content "Select yes if the work is controlled legal representation (CLR)"
  end

  context "with check answers" do
    let(:means_test_check_answers) { "Means tests for under 18s" }

    context "with under 18 clr" do
      before do
        choose "Yes"
        click_on "Save and continue"
      end

      it "stores the chosen value in the session" do
        expect(session_contents["controlled_legal_representation"]).to be true
      end

      it "displays the data in check answers" do
        fill_in_forms_until(:check_answers)
        expect(page).not_to have_content means_test_check_answers
      end
    end

    context "without clr" do
      before do
        choose "No"
        click_on "Save and continue"
      end

      it "displays the data in check answers" do
        fill_in_forms_until(:check_answers)
        expect(page).to have_content means_test_check_answers
      end
    end
  end
end
