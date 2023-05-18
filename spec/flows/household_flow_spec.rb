require "rails_helper"

RSpec.describe "Household section flow", :household_section_flag, type: :feature do
  it "puts property questions at the end" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen
    # property screen is skipped
    confirm_screen("vehicle")
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen
    # partner dependants screen is skipped
    confirm_screen("partner_housing_benefit")
    fill_in_forms_until(:partner_outgoings)
    fill_in_partner_outgoings_screen
    # partner property screen is skipped
    # partner vehicle screen is skipped
    confirm_screen("partner_assets")
    fill_in_partner_assets_screen
    confirm_screen("property")
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_property_entry_screen
    confirm_screen("mortgage_or_loan_payment")
    fill_in_mortgage_or_loan_payment_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    confirm_screen("check_answers")
  end

  it "visits the appropriate screens, if property is owned outright" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen
    # property screen is skipped
    confirm_screen("vehicle")
    fill_in_forms_until(:partner_outgoings)
    fill_in_partner_outgoings_screen
    # partner property screen is skipped
    # partner vehicle screen is skipped
    confirm_screen("partner_assets")
    fill_in_partner_assets_screen
    confirm_screen("property")
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    confirm_screen("check_answers")
  end

  it "skips property if the client is asylum supported" do
    start_assessment
    fill_in_forms_until(:matter_type)
    fill_in_matter_type_screen(choice: "Asylum")
    fill_in_asylum_support_screen(choice: "Yes")
    confirm_screen("check_answers")
  end

  it "skips outgoing screens on certificated flow, if the client receives a passporting benefit" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    # outgoing screens are skipped
    confirm_screen "vehicle"
  end

  it "uses new vehicle details screen" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    confirm_screen "vehicles_details"
  end
end
