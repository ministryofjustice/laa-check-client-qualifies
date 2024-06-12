require "rails_helper"

RSpec.describe "assets", type: :feature do
  let(:level_of_help) { :controlled }
  let(:immigration_or_asylum) { false }
  let(:self_employed) { false }

  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(level_of_help)
    if immigration_or_asylum
      fill_in_forms_until(:immigration_or_asylum)
      fill_in_immigration_or_asylum_screen(choice: "Yes")
    end
    if self_employed
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(type: "Self-employment income")
    end
    fill_in_forms_until(:assets)
  end

  context "without conditional reveal assets", :legacy_assets_no_reveal do
    it "stores the chosen values in the session" do
      fill_in "bank_account_model[items][1][amount]", with: "234"
      fill_in "client_assets_form[investments]", with: "345"
      fill_in "client_assets_form[valuables]", with: "4560"
      click_on "Save and continue"

      expect(session_contents["bank_accounts"][0]["amount"]).to eq 234
      expect(session_contents["investments"]).to eq 345
      expect(session_contents["valuables"]).to eq 4560
    end
  end

  context "with conditional reveal assets" do
    it "stores the chosen values in the session" do
      fill_in "bank_account_model[items][1][amount]", with: "234"
      choose "Yes", name: "client_assets_form[investments_relevant]"
      fill_in "client_assets_form[investments]", with: "345"
      choose "Yes", name: "client_assets_form[valuables_relevant]"
      fill_in "client_assets_form[valuables]", with: "4560"
      click_on "Save and continue"

      expect(session_contents["bank_accounts"][0]["amount"]).to eq 234
      expect(session_contents["investments"]).to eq 345
      expect(session_contents["valuables"]).to eq 4560
    end

    it "shows appropriate error messages if valuables amount too low" do
      choose "Yes", name: "client_assets_form[valuables_relevant]"
      fill_in "client_assets_form[valuables]", with: "456"
      click_on "Save and continue"
      within ".govuk-error-summary__list" do
        expect(page.text).to include("Valuable items must be £500 or more")
      end
    end

    it "shows SMOD checkbox" do
      expect(page).to have_content(I18n.t("generic.dispute"))
    end
  end

  context "when this is an upper tribunal matter" do
    let(:immigration_or_asylum) { true }

    it "shows no SMOD checkbox" do
      expect(page).not_to have_content(I18n.t("generic.dispute"))
    end
  end

  it "shows content about special applicants" do
    expect(page).to have_content "Clients who are bankrupt"
  end

  context "when the check is certificated" do
    let(:level_of_help) { :certificated }

    it "shows appropriate links" do
      expect(page).to have_content "Clients who are bankrupt"
    end

    it "does not show content about self-employed applicants" do
      expect(page).not_to have_content "Business capital for self-employed clients"
    end

    context "when client is self-employed" do
      let(:self_employed) { true }

      it "shows content about self-employed applicants" do
        expect(page).to have_content "Business capital for self-employed clients"
      end
    end
  end

  context "when continuing to check answers" do
    before do
      fill_in_forms_until(:check_answers)
    end

    let(:valuables_content) { "Does your client have valuable items" }
    let(:investments_content) { "Does your client have any investments?" }

    context "with legacy non-reveals", :legacy_assets_no_reveal do
      it "hides the reveal question for valuables" do
        expect(page).not_to have_content valuables_content
      end

      it "hides the reveal question for investments" do
        expect(page).not_to have_content investments_content
      end
    end

    context "with asset reveals" do
      it "shows the reveal question for valuables" do
        expect(page).to have_content valuables_content
      end

      it "shows the reveal question for investments" do
        expect(page).to have_content investments_content
      end
    end
  end
end
