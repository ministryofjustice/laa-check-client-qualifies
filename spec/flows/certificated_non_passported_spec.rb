require "rails_helper"

RSpec.describe "Certificated, non-passported flow", type: :feature do
  it "allows me a direct route to the check answers page" do
    start_assessment
    fill_in_provider_users_screen
    fill_in_applicant_screen
    fill_in_dependant_details_screen
    fill_in_housing_benefit_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_outgoings_screen
    fill_in_property_screen
    fill_in_vehicle_screen
    fill_in_assets_screen
    confirm_screen("check_answers")
  end

  it "asks for employment details if I am employed" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(employed: "Employed and in work")
    fill_in_dependant_details_screen
    fill_in_employment_screen
    confirm_screen("housing_benefit")
  end

  it "asks for employment details if I am on statutory pay" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(employed: "Employed and on Statutory Sick Pay or Statutory Maternity Pay")
    fill_in_dependant_details_screen
    fill_in_employment_screen
    confirm_screen("housing_benefit")
  end

  it "asks for housing benefit details if relevant" do
    start_assessment
    fill_in_forms_until(:housing_benefit)
    fill_in_housing_benefit_screen(choice: "Yes")
    fill_in_housing_benefit_details_screen
    confirm_screen("benefits")
  end

  it "asks for benefit details if relevant" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    start_assessment
    fill_in_forms_until(:benefits)
    fill_in_benefits_screen(choice: "Yes")
    fill_in_add_benefit_screen
    fill_in_benefits_screen
    confirm_screen("other_income")
  end

  it "asks for property details if property owned outright" do
    start_assessment
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    confirm_screen("vehicle")
  end

  it "asks for property details if property owned with mortgage" do
    start_assessment
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_property_entry_screen
    confirm_screen("vehicle")
  end

  it "asks for vehicle details if vehicle owned" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicle_details_screen
    confirm_screen("assets")
  end
end
