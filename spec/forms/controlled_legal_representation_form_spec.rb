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
    context "with under 18 clr" do
      before do
        choose "Yes"
        click_on "Save and continue"
      end

      it "stores the chosen value in the session" do
        expect(session_contents["controlled_legal_representation"]).to be true
      end

      context "when on check answers" do
        before do
          fill_in_forms_until(:check_answers)
        end

        it "shows correct sections" do
          expect(all(".govuk-summary-card__title").map(&:text))
            .to eq(
              ["Client age",
               "Level of help"],
            )
        end
      end
    end

    context "without clr" do
      before do
        choose "No"
        click_on "Save and continue"
        fill_in_forms_until(:check_answers)
      end

      it "shows correct sections" do
        expect(all(".govuk-summary-card__title").map(&:text))
          .to eq(
            ["Client age",
             "Level of help",
             "Means tests for under 18s"],
          )
      end
    end
  end
end
