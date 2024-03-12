require "rails_helper"

RSpec.describe "New outgoings flow", :stub_cfe_calls, :outgoings_flow_flag, type: :feature do
  it "shows new screen order when there is no partner and passported" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "No", passporting: "Yes")
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_assets_screen
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen("check_answers")
  end

  it "shows new screen order when there is a partner and passported" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "Yes")
    fill_in_partner_details_screen
    fill_in_property_screen(choice: "No")
    fill_in_additional_property_screen(choice: "No")
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen
    confirm_screen("check_answers")
  end

  it "shows new screen order when there is no partner and not passported" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "No", passporting: "No")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen
    fill_in_property_screen
    fill_in_housing_costs_screen
    fill_in_additional_property_screen
    fill_in_assets_screen
    fill_in_vehicle_screen
    confirm_screen("check_answers")
  end

  it "shows new screen order when there is a partner and not passported" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "No")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen
    fill_in_partner_outgoings_screen
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_mortgage_or_loan_payment_screen
    fill_in_property_entry_screen
    fill_in_additional_property_screen
    fill_in_partner_additional_property_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen
    confirm_screen("check_answers")
  end
end
