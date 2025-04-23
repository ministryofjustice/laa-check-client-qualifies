require "rails_helper"

RSpec.describe "Early result journey", type: :feature do
  context "when I am ineligible on gross income" do
    let(:partner_value) { "No" }

    before do
      first = instance_double(CfeResult, ineligible_gross_income?: true,
                                         gross_income_excess: 100,
                                         gross_income_result: "ineligible")
      second = instance_double(CfeResult, ineligible_gross_income?: false,
                                          gross_income_excess: 0,
                                          gross_income_result: "eligible")
      allow(CfeService).to receive(:result).and_return(first, second)
      allow(CfeService).to receive(:call).and_return build(:api_result, eligible: "ineligible")
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: partner_value, passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(gross: "8000", frequency: "Every month")
      fill_in_forms_until(:other_income)
      fill_in_other_income_screen_with_friends_and_family
    end

    it "when I continue the check" do
      confirm_screen("outgoings")
      expect(page).to have_content("Gross monthly income limit exceeded")
      fill_in_outgoings_screen
      expect(page).not_to have_content("Gross monthly income limit exceeded")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      expect(page).to have_current_path(/\A\/check-result/)
      expect(page).to have_content "Your client's key eligibility totals"
    end

    it "when I go straight to results the check" do
      confirm_screen("outgoings")
      expect(page).to have_content("Gross monthly income limit exceeded")
      click_on "Go to results page"
      expect(page).to have_current_path(/\A\/check-result/)
      expect(page).to have_content "Your client's key eligibility totals"
    end

    it "when I go straight to results and use the back button it shows the banner" do
      confirm_screen("outgoings")
      outgoings_url = current_path
      expect(page).to have_content("Gross monthly income limit exceeded")
      click_on "Go to results page"
      expect(page).to have_current_path(/\A\/check-result/)
      expect(page).to have_content "Your client's key eligibility totals"
      visit outgoings_url # simulates using the back button to return to outgoings
      expect(page).to have_content("Gross monthly income limit exceeded by")
      expect(page).to have_content("Go to results page")
    end

    context "when the early eligibility changes" do
      it "back links and banner work as expected" do
        confirm_screen("outgoings")
        expect(page).to have_content("Gross monthly income limit exceeded")
        click_on "Back"
        confirm_screen("other_income")
        expect(page).not_to have_content("Gross monthly income limit exceeded")
        click_on "Back"
        click_on "Back"
        confirm_screen("income")
        fill_in_income_screen(gross: "100", frequency: "Every month")
        click_on "Save and continue"
        fill_in_forms_until(:other_income)
        fill_in_other_income_screen_with_friends_and_family
        confirm_screen("outgoings")
        expect(page).not_to have_content("Gross monthly income limit exceeded")
      end
    end

    context "when I have partner" do
      let(:partner_value) { "Yes" }

      it "displays banner on correct screen" do
        confirm_screen("partner_details")
        expect(page).to have_content("Gross monthly income limit exceeded")
        fill_in_partner_details_screen
        fill_in_partner_employment_status_screen(choice: "Employed")
        fill_in_partner_income_screen(frequency: "Every week")
        fill_in_partner_benefits_screen(choice: "No")
        fill_in_partner_other_income_screen_with_family_and_other
        confirm_screen("outgoings")
        expect(page).not_to have_content("Gross monthly income limit exceeded")
        fill_in_outgoings_screen
        confirm_screen("partner_outgoings")
        expect(page).not_to have_content("Gross monthly income limit exceeded")
        fill_in_partner_outgoings_screen
      end
    end
  end

  context "when I am eligible" do
    before do
      allow(CfeService).to receive_messages(result: instance_double(CfeResult, ineligible_gross_income?: true,
                                                                               gross_income_excess: 0,
                                                                               gross_income_result: "eligible"), call: build(:api_result, eligible: "ineligible"))
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(gross: "100", frequency: "Every month")
      fill_in_forms_until(:other_income)
      fill_in_other_income_screen_with_friends_and_family
    end

    it "banner does not display and I can submit the check" do
      confirm_screen("outgoings")
      expect(page).not_to have_content("Gross monthly income limit exceeded")
      fill_in_outgoings_screen
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      expect(page).to have_current_path(/\A\/check-result/)
      expect(page).to have_content "Your client's key eligibility totals"
    end
  end
end
