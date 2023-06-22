require "rails_helper"

RSpec.describe "assets", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "controlled" }
  let(:session) { { "level_of_help" => level_of_help } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/assets"
  end

  it "shows appropriate error messages if form left blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Enter the total of all money in bank accounts. Enter 0 if this does not apply.",
        "Enter the total value of investments. Enter 0 if this does not apply.",
        "Enter the total value of items worth £500 or more. Enter 0 if this does not apply.",
      ].join
    end
  end

  it "stores the chosen values in the session" do
    fill_in "bank_account_model[items][1][amount]", with: "234"
    fill_in "client_assets_form[investments]", with: "345"
    fill_in "client_assets_form[valuables]", with: "4560"
    click_on "Save and continue"

    expect(session_contents["bank_accounts"][0]["amount"]).to eq 234
    expect(session_contents["investments"]).to eq 345
    expect(session_contents["valuables"]).to eq 4560
  end

  it "shows appropriate error messages if valuables amount too low" do
    fill_in "client_assets_form[valuables]", with: "456"
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to include("Valuable items must be £500 or more. Enter 0 if this does not apply.")
    end
  end

  it "shows SMOD checkbox" do
    expect(page).to have_content(I18n.t("generic.dispute"))
  end

  context "when this is an upper tribunal matter" do
    let(:session) { { "level_of_help" => "controlled", "immigration_or_asylum" => true } }

    it "shows no SMOD checkbox" do
      expect(page).not_to have_content(I18n.t("generic.dispute"))
    end
  end

  context "when special applicant groups enabled", :special_applicant_groups_flag do
    it "shows content about special applicants" do
      expect(page).to have_content "Clients who are bankrupt"
      expect(page).to have_content "Clients in prison"
    end

    context "when the check is certificated" do
      let(:session) { { "level_of_help" => "certificated" } }

      it "shows appropriate links" do
        expect(page).to have_content "Guidance on bankrupt clients"
      end

      context "when self_employed flag enabled", :self_employed_flag do
        it "does not show content about self-employed applicants" do
          expect(page).not_to have_content "Business capital for self-employed clients"
        end

        context "when client is self-employed" do
          let(:session) { { "level_of_help" => "certificated", "employment_status" => "in_work", "incomes" => [{ "income_type" => "self_employment" }] } }

          it "shows content about self-employed applicants" do
            expect(page).to have_content "Business capital for self-employed clients"
          end
        end
      end
    end
  end

  context "when no flags are enabled" do
    it "shows no content about special applicants" do
      expect(page).not_to have_content "Clients who are bankrupt"
      expect(page).not_to have_content "Clients in prison"
    end

    it "shows no content for self-employed applicants" do
      expect(page).not_to have_content "Business capital for self-employed clients"
    end

    context "when the check is certificated" do
      let(:session) { { "level_of_help" => "certificated" } }

      it "hides irrelevant links" do
        expect(page).not_to have_content "Guidance on bankrupt clients"
      end
    end
  end
end
