require "rails_helper"

RSpec.describe "Partner employment page", :partner_flag do
  let(:partner_employment_page_header) { I18n.t("estimate_flow.partner_employment.heading") }
  let(:assets_page_header) { I18n.t("estimate_flow.assets.assets.legend") }

  before do
    visit_applicant_page_with_partner
  end

  context "when I have indicated that the partner is unemployed" do
    before do
      fill_in_applicant_screen_without_passporting_benefits
      select_applicant_boolean(:partner_employed, false)
      select_applicant_boolean(:partner_over_60, false)
      click_on "Save and continue"
      travel_from_dependants_to_past_client_assets
    end

    it "skips the partner employment page" do
      expect(page).not_to have_content(partner_employment_page_header)
    end
  end

  context "when I have indicated that the partner is employed" do
    before do
      fill_in_applicant_screen_without_passporting_benefits
      select_applicant_boolean(:partner_employed, true)
      select_applicant_boolean(:partner_over_60, false)
      click_on "Save and continue"
      travel_from_dependants_to_past_client_assets
    end

    it "shows the partner employment page" do
      expect(page).to have_content(partner_employment_page_header)
    end

    it "has a back link to the assets page" do
      click_link "Back"
      expect(page).to have_content assets_page_header
    end

    context "when I omit some required information" do
      before do
        click_on "Save and continue"
      end

      it "shows me a partner-specific error message" do
        expect(page).to have_content partner_employment_page_header
        expect(page).to have_content "Please select how frequently your client's partner receives employment income"
      end
    end

    context "when I provide all required information" do
      before do
        fill_in "partner-employment-form-gross-income-field", with: "5,000"
        fill_in "partner-employment-form-income-tax-field", with: "1000"
        fill_in "partner-employment-form-national-insurance-field", with: 50.5
        click_checkbox("partner-employment-form-frequency", "monthly")
      end

      it "Moves me on to the next question and stores my answers" do
        prev_path = current_path
        click_on "Save and continue"
        expect(page).not_to have_content partner_employment_page_header
        visit prev_path
        expect(find("#partner-employment-form-gross-income-field").value).to eq "5,000"
        expect(find("#partner-employment-form-income-tax-field").value).to eq "1,000"
        expect(find("#partner-employment-form-national-insurance-field").value).to eq "50.50"
      end
    end
  end
end
