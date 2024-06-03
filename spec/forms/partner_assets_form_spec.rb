require "rails_helper"

RSpec.describe "partner_assets", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "controlled" }
  let(:session) { { "level_of_help" => level_of_help } }

  before do
    set_session(assessment_code, session)
    visit form_path(:partner_assets, assessment_code)
  end

  it "shows appropriate error messages if form left blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Enter total money in bank account. Enter 0 if this does not apply.",
        "Enter the total value of investments. Enter 0 if this does not apply.",
        "Enter the value of items worth £500 or more. Enter 0 if this does not apply.",
      ].join
    end
  end

  it "stores the chosen values in the session" do
    fill_in "bank_account_model[items][1][amount]", with: "234"
    fill_in "partner_assets_form[investments]", with: "345"
    fill_in "partner_assets_form[valuables]", with: "4560"
    click_on "Save and continue"

    expect(session_contents["partner_bank_accounts"][0]["amount"]).to eq 234
    expect(session_contents["partner_investments"]).to eq 345
    expect(session_contents["partner_valuables"]).to eq 4560
  end

  it "shows appropriate error messages if valuables amount too low" do
    fill_in "partner_assets_form[valuables]", with: "456"
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to include("Valuable items must be £500 or more. Enter 0 if this does not apply")
    end
  end

  context "when the check is certificated" do
    let(:level_of_help) { "certificated" }

    it "shows appropriate links" do
      expect(page).to have_content "Clients with partners who are prisoners"
    end

    context "when client is self-employed" do
      let(:session) do
        {
          "level_of_help" => level_of_help,
          "partner" => true,
          "partner_employment_status" => "in_work",
          "partner_incomes" => [{ "income_type" => "self_employment" }],
        }
      end

      it "shows content about self-employed applicants" do
        expect(page).to have_content "Business capital for self-employed clients"
      end
    end
  end
end
