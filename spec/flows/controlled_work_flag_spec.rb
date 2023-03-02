require "rails_helper"

RSpec.describe "Controlled work flag", :controlled_flag, type: :feature do
  it "adds a new screen that has no other effect on a certificated check" do
    start_assessment
    fill_in_provider_screen
    fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
    fill_in_applicant_screen
    fill_in_dependants_screen
    fill_in_housing_benefit_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_outgoings_screen
    fill_in_property_screen
    fill_in_vehicle_screen
    fill_in_assets_screen
    confirm_screen("check_answers")
  end

  it "skips the vehicle screens on a controlled work check" do
    start_assessment
    fill_in_provider_screen
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_applicant_screen(partner: "Yes")
    fill_in_dependants_screen
    fill_in_client_income_screens
    fill_in_property_screen
    fill_in_assets_screen
    fill_in_partner_details_screen
    fill_in_partner_dependants_screen
    fill_in_partner_income_screens
    fill_in_partner_property_screen
    fill_in_partner_assets_screen
    confirm_screen("check_answers")
  end
end
