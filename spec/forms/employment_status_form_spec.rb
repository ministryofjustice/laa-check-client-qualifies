require "rails_helper"

RSpec.describe "employment status form", :calls_cfe_early_returns_not_ineligible, type: :feature do
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
    context "when employed" do
      before do
        choose "Employed or self-employed", name: "employment_status_form[employment_status]"
        click_on "Save and continue"
      end

      it "stores the employed value in the session" do
        expect(session_contents["employment_status"]).to eq "in_work"
      end

      context "when on check answers" do
        before do
          fill_in_forms_until(:check_answers)
        end

        it "shows correct sections" do
          expect(all(".govuk-summary-card__title").map(&:text))
            .to eq(
              ["Client age",
               "Partner and passporting",
               "Level of help",
               "Type of matter",
               "Type of immigration or asylum matter",
               "Number of dependants",
               "Employment status",
               "Client employment income 1",
               "Client benefits",
               "Client other income",
               "Client outgoings and deductions",
               "Home client lives in",
               "Housing costs",
               "Client other property",
               "Client assets",
               "Vehicles"],
            )
        end
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

      context "when on check answers" do
        before do
          fill_in_forms_until(:check_answers)
        end

        it "shows correct sections" do
          expect(all(".govuk-summary-card__title").map(&:text))
            .to eq(
              ["Client age",
               "Partner and passporting",
               "Level of help",
               "Type of matter",
               "Type of immigration or asylum matter",
               "Number of dependants",
               "Employment status",
               "Client benefits",
               "Client other income",
               "Client outgoings and deductions",
               "Home client lives in",
               "Housing costs",
               "Client other property",
               "Client assets",
               "Vehicles"],
            )
        end
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
