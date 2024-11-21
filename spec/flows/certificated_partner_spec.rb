require "rails_helper"

RSpec.describe "Certificated, non-passported flow with partner", :stub_cfe_calls_with_webmock, type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
  end

  context "when asking for all partner details" do
    before do
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
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_partner_additional_property_screen
      fill_in_assets_screen
      fill_in_partner_assets_screen
      fill_in_vehicle_screen
    end

    it "hits check answers" do
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
           "Partner age",
           "Partner employment status",
           "Partner benefits",
           "Partner other income",
           "Client outgoings and deductions",
           "Partner outgoings and deductions",
           "Home client usually lives in",
           "Housing costs",
           "Client other property",
           "Partner other property",
           "Client assets",
           "Partner assets",
           "Vehicles"],
        )
    end
  end

  it "asks for employment details if relevant" do
    fill_in_forms_until(:partner_details)
    fill_in_partner_details_screen
    fill_in_partner_employment_status_screen(choice: "Employed")
    fill_in_partner_income_screen
    confirm_screen("partner_benefits")
  end

  it "asks for benefit details if relevant" do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])

    fill_in_forms_until(:partner_benefits)
    fill_in_partner_benefits_screen(choice: "Yes")
    fill_in_partner_benefit_details_screen
    confirm_screen("partner_other_income")
  end

  it "asks for partner additional property details if property owned outright" do
    fill_in_forms_until(:partner_additional_property)
    fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
    fill_in_partner_additional_property_details_screen
    confirm_screen("assets")
  end

  it "asks for partner additional property details if property owned with a mortgage" do
    fill_in_forms_until(:partner_additional_property)
    fill_in_partner_additional_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_partner_additional_property_details_screen
    confirm_screen("assets")
  end
end
