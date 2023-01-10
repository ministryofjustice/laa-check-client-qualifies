require "rails_helper"

RSpec.describe "Partner employment page", :partner_flag do
  let(:partner_employment_page_header) { I18n.t("estimate_flow.partner_employment.heading") }
  let(:partner_dependants_header) { "Tell us about your client's partner's dependants" }
  let(:partner_details_page_header) { I18n.t("estimate_flow.partner_details.partner_heading") }

  context "when I have indicated that the partner is unemployed" do
    before do
      visit_flow_page(passporting: false, partner: true, target: :partner_details)
      select_boolean_value("partner-details-form", :over_60, false)
      select_boolean_value("partner-details-form", :employed, false)
      click_on "Save and continue"
    end

    it "skips the partner employment page" do
      expect(page).not_to have_content(partner_employment_page_header)
    end
  end

  context "when I have indicated that the partner is employed" do
    before do
      visit_flow_page(passporting: false, partner: true, target: :partner_employment) do |step|
        case step
        when :partner_details
          select_boolean_value("partner-details-form", :over_60, false)
          select_boolean_value("partner-details-form", :employed, true)
        end
      end
    end

    it "shows the partner employment page" do
      expect(page).to have_content(partner_employment_page_header)
    end

    it "has a back link to the partner dependants page" do
      click_link "Back"
      expect(page).to have_content partner_dependants_header
    end

    context "when I omit some required information" do
      before do
        click_on "Save and continue"
      end

      it "shows me a partner-specific error message" do
        expect(page).to have_content partner_employment_page_header
        expect(page).to have_content "Select how frequently your client's partner receives employment income"
      end
    end

    context "when I provide all required information" do
      before do
        fill_in "partner-employment-form-gross-income-field", with: "5,000"
        fill_in "partner-employment-form-income-tax-field", with: "1000"
        fill_in "partner-employment-form-national-insurance-field", with: 50.5
        select_radio_value("partner-employment-form", "frequency", "monthly")
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
