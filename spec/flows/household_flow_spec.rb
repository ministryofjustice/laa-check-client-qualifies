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
    fill_in_forms_until(:partner_outgoings)
    fill_in_partner_outgoings_screen
    # partner property screen is skipped
    confirm_screen("partner_vehicle")
    fill_in_partner_vehicle_screen
    fill_in_partner_assets_screen
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    confirm_screen("check_answers")
  end

  it "skips property if the client is asylum supported" do
    start_assessment
    fill_in_forms_until(:matter_type)
    fill_in_matter_type_screen(choice: "Asylum")
    fill_in_asylum_support_screen(choice: "Yes")
    confirm_screen("check_answers")
  end
end
