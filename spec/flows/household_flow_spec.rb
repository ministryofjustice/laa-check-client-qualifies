require "rails_helper"

RSpec.describe "Household section flow", :stub_cfe_calls_with_webmock, type: :feature do
  it "runs through a full non-passported application with a partner" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_partner_details_screen
    fill_in_partner_employment_status_screen
    fill_in_partner_benefits_screen
    fill_in_partner_other_income_screen
    fill_in_outgoings_screen
    fill_in_partner_outgoings_screen
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    puts page.html
    fill_in_mortgage_or_loan_payment_screen
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen("check_answers")
  end

  context "with a full non-passported application without a partner" do
    before do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_outgoings_screen
      fill_in_property_screen(choice: "Yes, with a mortgage or loan")
      fill_in_mortgage_or_loan_payment_screen
      fill_in_property_entry_screen
      fill_in_additional_property_screen(choice: "Yes, owned outright")
      fill_in_additional_property_details_screen
      fill_in_assets_screen
      fill_in_vehicle_screen(choice: "Yes")
      fill_in_vehicles_details_screen
    end

    it "runs through a full non-passported application without a partner" do
      confirm_screen("check_answers")
    end

    it "shows correct sections" do
      expect(all(".govuk-summary-card__title").map(&:text))
        .to eq(
          ["Client age",
           "Partner and passporting",
           "Level of help",
           "Type of matter",
           "Type of immigration or asylum matter",
           "Number of dependants",
           "Employment status",
           "Client benefits",
           "Client other income",
           "Client outgoings and deductions",
           "Home client usually lives in",
           "Housing costs",
           "Home client lives in equity",
           "Client other property",
           "Client other property 1 details",
           "Client assets",
           "Vehicles",
           "Vehicle 1 details"],
        )
    end
  end

  it "runs through a full passported application with a partner" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes", passporting: "Yes")
    fill_in_partner_details_screen
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen(choice: "Yes")
    fill_in_vehicles_details_screen
    confirm_screen("check_answers")
  end

  it "runs through a full passported application without a partner" do
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

  it "visits the appropriate screens, if property is owned outright" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen
    fill_in_forms_until(:partner_outgoings)
    fill_in_partner_outgoings_screen
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    fill_in_additional_property_screen(choice: "Yes, owned outright")
    fill_in_additional_property_details_screen
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    fill_in_assets_screen
    fill_in_partner_assets_screen
    fill_in_vehicle_screen
    confirm_screen("check_answers")
  end

  it "skips property if the client is asylum supported" do
    start_assessment
    fill_in_forms_until(:immigration_or_asylum_type_upper_tribunal)
    fill_in_immigration_or_asylum_type_upper_tribunal_screen(choice: "Yes, asylum (Upper Tribunal)")
    fill_in_asylum_support_screen(choice: "Yes")
    confirm_screen("check_answers")
  end

  it "uses new vehicle details screen" do
    start_assessment
    fill_in_forms_until(:vehicle)
    fill_in_vehicle_screen(choice: "Yes")
    confirm_screen "vehicles_details"
  end
end
