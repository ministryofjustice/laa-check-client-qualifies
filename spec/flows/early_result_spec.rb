require "rails_helper"

RSpec.describe "Early result journey", type: :feature do
  # expected to fail when ee banner is turned on - tests can be deleted
  context "when I am ineligible on gross income" do
    before do
      allow(CfeService).to receive(:result).and_return(instance_double(CfeResult, ineligible_gross_income?: true,
                                                                                  gross_income_excess: 100))
    end

    it "when I continue the check" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(gross: "8000", frequency: "Every month")
      fill_in_forms_until(:other_income)
      fill_in_other_income_screen_with_friends_and_family
      fill_in_ineligible_gross_income_screen
      confirm_screen("outgoings")
      fill_in_outgoings_screen
    end

    it "when I stop the check" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(gross: "8000", frequency: "Every month")
      fill_in_forms_until(:other_income)
      fill_in_other_income_screen_with_friends_and_family
      fill_in_ineligible_gross_income_screen(choice: "Skip remaining questions")
      confirm_screen("check_answers")
    end

    it "back links work as expected" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(gross: "8000", frequency: "Every month")
      fill_in_forms_until(:other_income)
      fill_in_other_income_screen_with_friends_and_family
      confirm_screen("ineligible_gross_income")
      click_on "Back"
      confirm_screen("other_income")
      click_on "Save and continue"
      fill_in_ineligible_gross_income_screen(choice: "Skip remaining questions")
      confirm_screen("check_answers")
      click_on "Back"
      confirm_screen("ineligible_gross_income")
    end
  end

  # new ee banner functionality - tests should all pass and be kept
  context "with ee banner switched on", :ee_banner, type: :feature do
    context "when I am ineligible on gross income" do
      before do
        first = instance_double(CfeResult, ineligible_gross_income?: true,
                                           gross_income_excess: 100,
                                           gross_income_result: "ineligible")
        second = instance_double(CfeResult, ineligible_gross_income?: false,
                                            gross_income_excess: 0,
                                            gross_income_result: "eligible")
        allow(CfeService).to receive(:result).and_return(first, second)
        start_assessment
        fill_in_forms_until(:applicant)
        fill_in_applicant_screen(partner: "No", passporting: "No")
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
      end

      it "when I go straight to results the check" do
        allow(CfeService).to receive(:call).and_return build(:api_result, eligible: "ineligible")
        confirm_screen("outgoings")
        expect(page).to have_content("Gross monthly income limit exceeded")
        click_on "Go to results page"
        expect(page).to have_current_path(/\A\/check-result/)
      end

      # i've used this test to document the current behaviour of the banner
      context "when the early eligibility changes" do
        it "back links work as expected" do
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
    end
  end
end
