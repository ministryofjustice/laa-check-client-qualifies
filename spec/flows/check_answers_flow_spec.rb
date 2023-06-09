require "rails_helper"

RSpec.describe "Check answers", type: :feature do
  it "prompts me to fill screens were previously skipped, skipping screens that were previously filled" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(employed: "Unemployed")
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    within "#section-client_details-header" do
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
    within "#section-client_details-header" do
      click_on "Change"
    end
    fill_in_applicant_screen(passporting: "No", employed: "Employed and in work")
    fill_in_dependant_details_screen
    fill_in_employment_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_outgoings_screen
    fill_in_housing_costs_screen
    confirm_screen("check_answers")
  end

  it "takes me on mini loops" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    within "#section-household_vehicles-header" do
      click_on "Change"
    end
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen("check_answers")
  end

  it "behaves as expected when there are validation errors" do
    start_assessment
    fill_in_forms_until(:check_answers)
    within "#section-assets-header" do
      click_on "Change"
    end
    fill_in_assets_screen(values: { savings: "" })
    confirm_screen("assets")
    fill_in_assets_screen
    confirm_screen("check_answers")
  end

  it "can handle a switch from certificated domestic abuse to controlled" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
    fill_in_matter_type_screen(choice: "Domestic abuse")
    fill_in_forms_until(:check_answers)
    within "#section-level_of_help-header" do
      click_on "Change"
    end
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_immigration_or_asylum_screen
    confirm_screen("check_answers")
  end
end
