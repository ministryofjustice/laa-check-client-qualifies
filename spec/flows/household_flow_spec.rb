require "rails_helper"

RSpec.describe "Household section flow", :household_section_flag, type: :feature do
  it "runs through a full non-passported application with a partner" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_partner_details_screen
    fill_in_partner_benefits_screen
    fill_in_partner_other_income_screen
    fill_in_outgoings_screen
    fill_in_partner_outgoings_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    confirm_screen("check_answers")
  end

  it "runs through a full passported application with a partner" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "Yes")
    fill_in_partner_details_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    confirm_screen("check_answers")
  end

  # it "includes partner_details in the flow when applicant is passported" do
  #   start_assessment
  #   fill_in_forms_until(:applicant)
  #   fill_in_applicant_screen(partner: "Yes", passporting: "Yes")
  #   confirm_screen("partner_details")
  #   fill_in_partner_details_screen
  #   confirm_screen("assets")
  #   fill_in_assets_screen
  #   confirm_screen("partner_assets")
  #   fill_in_partner_assets_screen
  #   fill_in_vehicle_screen
  #   fill_in_property_screen(choice: "Yes, owned outright")
  #   fill_in_property_entry_screen
  #   fill_in_additional_property_screen(choice: "Yes, owned outright")
  #   fill_in_additional_property_details_screen
  #   fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
  #   fill_in_partner_additional_property_details_screen
  #   confirm_screen("check_answers")
  # end

  it "visits the appropriate screens, if property is owned outright" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen
    # property screen is skipped
    fill_in_forms_until(:partner_outgoings)
    fill_in_partner_outgoings_screen
    # partner property screen is skipped
    # partner vehicle screen is skipped
    confirm_screen("assets")
    fill_in_assets_screen
    confirm_screen("partner_assets")
    fill_in_partner_assets_screen
    fill_in_vehicle_screen
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
    fill_in_applicant_screen(partner: "Yes", passporting: "Yes")
    # outgoing screens are skipped
    confirm_screen("partner_details")
  end

  it "uses new vehicle details screen" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    confirm_screen "vehicles_details"
  end
end
