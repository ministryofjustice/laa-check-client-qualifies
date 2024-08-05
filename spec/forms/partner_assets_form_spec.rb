require "rails_helper"

RSpec.describe "partner_assets", type: :feature do
  let(:level_of_help) { "controlled" }
  let(:self_employed) { false }

  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_with(level_of_help.to_sym)
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")

    if self_employed
      fill_in_forms_until(:partner_employment_status)
      fill_in_partner_employment_status_screen(choice: "Employed or self-employed")
      fill_in_partner_income_screen(type: "Self-employment income")
    end
    fill_in_forms_until(:partner_assets)
  end

  it "stores the chosen values in the session" do
    fill_in "bank_account_model[items][1][amount]", with: "234"
    choose "Yes", name: "partner_assets_form[investments_relevant]"
    fill_in "partner_assets_form[investments]", with: "345"
    choose "Yes", name: "partner_assets_form[valuables_relevant]"
    fill_in "partner_assets_form[valuables]", with: "4560"
    click_on "Save and continue"

    expect(session_contents["partner_bank_accounts"][0]["amount"]).to eq 234
    expect(session_contents["partner_investments"]).to eq 345
    expect(session_contents["partner_valuables"]).to eq 4560
  end

  context "when the check is certificated" do
    let(:level_of_help) { "certificated" }

    it "shows appropriate links" do
      expect(page).to have_content "Clients with partners who are prisoners"
    end

    context "when partner is self-employed" do
      let(:self_employed) { true }

      it "shows content about self-employed applicants" do
        expect(page).to have_content "Business capital for self-employed clients"
      end
    end
  end
end
