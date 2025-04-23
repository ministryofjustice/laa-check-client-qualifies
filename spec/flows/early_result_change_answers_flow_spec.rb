require "rails_helper"

RSpec.describe "Change answers after early result", type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  def stub_cfe_gross_eligible
    stub_request(:post, %r{assessments\z}).to_return(
      body: FactoryBot.build(:api_result,
                             result_summary: build(:result_summary,
                                                   gross_income: build(:gross_income_summary,
                                                                       proceeding_types: build_list(:proceeding_type, 1, result: "eligible")))).to_json,
      headers: { "Content-Type" => "application/json" },
    )
  end

  context "when starting as ineligible on gross income but continuing the check", :stub_cfe_gross_ineligible do
    before do
      start_assessment
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed")
      fill_in_income_screen(gross: "2700")
      fill_in_benefits_screen
      fill_in_other_income_screen
      confirm_screen("outgoings")
      fill_in_forms_until("check_answers")
    end

    it "does not display banner from Change Answers page" do
      within "#table-employment_status" do
        click_on "Change"
      end
      expect(page).not_to have_content("Gross monthly income limit exceeded")
      fill_in_employment_status_screen(choice: "Unemployed")
      confirm_screen("check_answers")
    end

    it "takes me on mini loops" do
      start_assessment
      fill_in_forms_until(:vehicle)
      fill_in_vehicle_screen(choice: "Yes")
      fill_in_vehicles_details_screen
      fill_in_forms_until(:check_answers)
      confirm_screen("check_answers")
      within "#table-vehicle" do
        click_on "Change"
      end
      fill_in_vehicle_screen(choice: "Yes")
      fill_in_vehicles_details_screen
      confirm_screen("check_answers")
    end

    it "change to passported successfully" do
      within "#table-applicant" do
        click_on "Change"
      end
      fill_in_applicant_screen(passporting: "Yes")
      confirm_screen("check_answers")
    end

    it "change dependants successfully" do
      within "#table-dependant_details" do
        click_on "Change"
      end
      fill_in_dependant_details_screen({ child_dependants: "Yes", child_dependants_count: 1 })
      fill_in_dependant_income_screen
      confirm_screen("outgoings")
      fill_in_outgoings_screen
      confirm_screen("check_answers")
      click_on "Submit"
      expect(page).to have_current_path(/\A\/check-result/)
      # check that result isn't 'your answers have been deleted'
      expect(page).to have_content "Your client's key eligibility totals"
    end
  end

  context "when starting as eligible on gross income" do
    before do
      start_assessment
      stub_cfe_gross_eligible
      fill_in_forms_until(:employment_status)
      fill_in_employment_status_screen(choice: "Employed")
      fill_in_income_screen(gross: "1000")
      fill_in_benefits_screen
      fill_in_other_income_screen
      confirm_screen("outgoings")
      fill_in_forms_until("check_answers")
    end

    it "does not display banner" do
      within "#table-income" do
        click_on "Change"
      end
      fill_in_income_screen(gross: "3000", frequency: "Every month")
      confirm_screen("check_answers")
      expect(page).not_to have_content("Gross monthly income limit exceeded")
    end
  end
end
