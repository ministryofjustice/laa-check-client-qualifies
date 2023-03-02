require "rails_helper"

RSpec.describe "Certificated, non-passported flow with partner", type: :feature do
  it "asks for all partner details" do
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
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
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen(employed: "Employed and in work")
    fill_in_partner_dependants_screen
    fill_in_partner_employment_screen
    confirm_screen("partner_housing_benefit")
  end

  it "asks for housing benefit details if relevant" do
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_housing_benefit_screen(choice: "Yes")
    fill_in_partner_housing_benefit_details_screen
    confirm_screen("partner_benefits")
  end

  it "asks for benefit details if relevant" do
    allow(CfeConnection).to receive(:connection).and_return(
      instance_double(CfeConnection, state_benefit_types: []),
    )

    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_housing_benefit_screen
    fill_in_partner_benefits_screen(choice: "Yes")
    fill_in_add_partner_benefit_screen
    fill_in_partner_benefits_screen
    confirm_screen("partner_other_income")
  end

  it "skips partner property if client owns home" do
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_details_screen
    fill_in_vehicle_screen
    fill_in_assets_screen
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_income_screens
    fill_in_partner_vehicle_screen
    fill_in_partner_assets_screen
    confirm_screen("check_answers")
  end

  it "asks for property details if property owned outright" do
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_income_screens
    fill_in_partner_property_screen(choice: "Yes, owned outright")
    fill_in_partner_property_details_screen
    confirm_screen("partner_vehicle")
  end

  it "asks for property details if property owned with mortgage" do
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_income_screens
    fill_in_partner_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_partner_property_details_screen
    confirm_screen("partner_vehicle")
  end

  it "asks for vehicle details if vehicle owned" do
    start_assessment
    fill_in_provider_screen
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_client_capital_screens
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_income_screens
    fill_in_partner_property_screen
    fill_in_partner_vehicle_screen(choice: "Yes")
    fill_in_partner_vehicle_details_screen
    confirm_screen("partner_assets")
  end
end
