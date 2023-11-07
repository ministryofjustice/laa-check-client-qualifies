require "rails_helper"

RSpec.describe "Change answers", type: :feature do
  it "prompts me to fill screens were previously skipped, and saving my changes" do
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Unemployed")
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    within "#table-employment_status" do
      click_on "Change"
    end
    fill_in_employment_status_screen(choice: "Employed")
    fill_in_income_screen
    confirm_screen("check_answers")
    expect(page).to have_content "What is your client's employment status?Employed or self-employed"
  end

  it "does not save my changes if I back out of them" do
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Unemployed")
    fill_in_forms_until(:check_answers)
    confirm_screen("check_answers")
    check_answers_url = current_path
    within "#table-employment_status" do
      click_on "Change"
    end
    fill_in_employment_status_screen(choice: "Employed")
    visit check_answers_url # simulate clicking 'back' twice from employment details screen
    confirm_screen("check_answers")
    expect(page).to have_content "What is your client's employment status?Unemployed"
  end

  it "can handle a switch from passporting to not" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:check_answers)
    within "#table-applicant" do
      click_on "Change"
    end
    fill_in_applicant_screen(passporting: "No", employed: "Employed and in work")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen
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
    within "#table-vehicle" do
      click_on "Change"
    end
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen("check_answers")
  end

  it "behaves as expected when there are validation errors" do
    start_assessment
    fill_in_forms_until(:check_answers)
    within "#table-assets" do
      click_on "Change"
    end
    fill_in_assets_screen(values: { investments: "" })
    confirm_screen("assets")
    fill_in_assets_screen
    confirm_screen("check_answers")
  end

  it "can handle a switch from certificated domestic abuse to controlled" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
    fill_in_domestic_abuse_applicant_screen(choice: "Yes")
    fill_in_forms_until(:check_answers)
    within "#table-level_of_help" do
      click_on "Change"
    end
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_immigration_or_asylum_screen
    confirm_screen("check_answers")
  end
end
