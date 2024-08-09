require "rails_helper"

RSpec.describe "Certificated, passported flow", :might_call_cfe, type: :feature do
  before do
    start_assessment
  end

  describe "check answers screen" do
    let(:income_section_text) { "Client income" }

    before do
      fill_in_client_age_screen
      fill_in_level_of_help_screen
      fill_in_domestic_abuse_applicant_screen
      fill_in_immigration_or_asylum_type_upper_tribunal_screen
    end

    context "with passporting" do
      it "doesnt show income section" do
        fill_in_applicant_screen(passporting: "Yes")
        fill_in_property_screen
        fill_in_additional_property_screen
        fill_in_assets_screen
        fill_in_vehicle_screen
        confirm_screen(:check_answers)
        expect(page).not_to have_content(income_section_text)
      end
    end

    context "without passporting" do
      it "shows income section as questions have been asked" do
        fill_in_applicant_screen(passporting: "No")
        fill_in_forms_until(:check_answers)
        expect(page).to have_content(income_section_text)
      end
    end
  end

  it "asks for property details if relevant" do
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    confirm_screen("additional_property")
  end

  it "asks for additional property details if relevant" do
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:additional_property)
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    confirm_screen("assets")
  end

  it "asks for vehicle details if vehicle owned" do
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(passporting: "Yes")
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen(:check_answers)
  end
end
