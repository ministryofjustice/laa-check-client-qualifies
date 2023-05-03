require "rails_helper"

RSpec.describe "Certificated, non-passported flow with partner", type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
  end

  it "asks for all partner details" do
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen
    fill_in_partner_dependant_details_screen
    fill_in_partner_housing_benefit_screen
    fill_in_partner_benefits_screen
    fill_in_partner_other_income_screen
    fill_in_partner_outgoings_screen
    fill_in_partner_property_screen
    fill_in_partner_vehicle_screen
    fill_in_partner_assets_screen
    confirm_screen("check_answers")
  end

  it "asks for employment details if relevant" do
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen(employed: "Employed and in work")
    fill_in_partner_dependant_details_screen
    fill_in_partner_employment_screen
    confirm_screen("partner_housing_benefit")
  end

  it "asks for housing benefit details if relevant" do
    fill_in_forms_until(:partner_housing_benefit)
    fill_in_partner_housing_benefit_screen(choice: "Yes")
    fill_in_partner_housing_benefit_details_screen
    confirm_screen("partner_benefits")
  end

  it "asks for benefit details if relevant" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    fill_in_forms_until(:partner_benefits)
    fill_in_partner_benefits_screen(choice: "Yes")
    fill_in_partner_benefit_details_screen
    confirm_screen("partner_other_income")
  end

  it "skips partner property if client owns home" do
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_forms_until(:partner_outgoings)
    fill_in_partner_outgoings_screen
    confirm_screen("partner_vehicle")
    fill_in_forms_until(:check_answers)
  end

  it "asks for property details if property owned outright" do
    fill_in_forms_until(:partner_property)
    fill_in_partner_property_screen(choice: "Yes, owned outright")
    fill_in_partner_property_entry_screen
    confirm_screen("partner_vehicle")
  end

  it "asks for property details if property owned with mortgage" do
    fill_in_forms_until(:partner_property)
    fill_in_partner_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_partner_property_entry_screen
    confirm_screen("partner_vehicle")
  end

  it "asks for vehicle details if vehicle owned" do
    fill_in_forms_until(:partner_vehicle)
    fill_in_partner_vehicle_screen(choice: "Yes")
    fill_in_partner_vehicle_details_screen
    confirm_screen("partner_assets")
  end
end
