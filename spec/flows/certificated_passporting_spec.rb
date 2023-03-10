require "rails_helper"

RSpec.describe "Certificated, passported flow", type: :feature do
  it "allows me a direct route to the check answers page" do
    start_assessment
    fill_in_provider_users_screen
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_property_screen
    fill_in_vehicle_screen
    fill_in_assets_screen
    confirm_screen("check_answers")
  end

  it "asks for property details if relevant" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    confirm_screen("vehicle")
  end

  it "asks for vehicle details if vehicle owned" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicle_details_screen
    confirm_screen("assets")
  end
end
