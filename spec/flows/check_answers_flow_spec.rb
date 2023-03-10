require "rails_helper"

RSpec.describe "Check answers", type: :feature do
  it "prompts me to fill screens were previously skipped, skipping screens that were previously filled" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(employed: "Unemployed")
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    within "#subsection-client_details-header" do
      click_on "Change"
    end
    fill_in_applicant_screen(employed: "Employed and in work")
    fill_in_employment_screen
    confirm_screen("check_answers")
  end

  it "can handle a switch from passporting to not" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:check_answers)
    within "#subsection-client_details-header" do
      click_on "Change"
    end
    fill_in_applicant_screen(passporting: "No", employed: "Employed and in work")
    fill_in_dependant_details_screen
    fill_in_employment_screen
    fill_in_housing_benefit_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_outgoings_screen
    confirm_screen("check_answers")
  end

  it "takes me on mini loops" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicle_details_screen
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    within "#subsection-vehicles-header" do
      click_on "Change"
    end
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicle_details_screen
    confirm_screen("check_answers")
  end

  it "behaves as expected when there are validation errors" do
    start_assessment
    fill_in_forms_until(:check_answers)
    within "#subsection-client_dependant_details-header" do
      click_on "Change"
    end
    fill_in_dependant_details_screen(child_dependants: "Yes", child_dependants_count: "")
    confirm_screen("dependant_details")
    fill_in_dependant_details_screen
    confirm_screen("check_answers")
  end
end
