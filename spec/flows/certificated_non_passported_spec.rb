require "rails_helper"

RSpec.describe "Certificated, non-passported flow", :stub_cfe_calls_with_webmock, type: :feature do
  context "when allows me a direct route to the check answers page" do
    before do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen
      fill_in_benefits_screen
      fill_in_other_income_screen
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_assets_screen
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
           "Client outgoings and deductions",
           "Home client lives in",
           "Housing costs",
           "Client other property",
           "Client assets",
           "Vehicles"],
        )
    end
  end

  context "when doing a certificated, domestic abuse case" do
    before do
      start_assessment
      fill_in_forms_until(:domestic_abuse_applicant)
      fill_in_domestic_abuse_applicant_screen(choice: "Yes")
      fill_in_forms_until(:check_answers)
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
           "Number of dependants",
           "Employment status",
           "Client benefits",
           "Client other income",
           "Client outgoings and deductions",
           "Home client lives in",
           "Housing costs",
           "Client other property",
           "Client assets",
           "Vehicles"],
        )
    end
  end

  # This test was inspired by the bug documented here https://dsdmoj.atlassian.net/browse/EL-1383
  it "allows me to save my answers after a validation error" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "No", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen
    fill_in_benefits_screen
    confirm_screen("other_income")
    click_on "Save and continue" # to trigger validation
    expect(page).to have_content "Select yes if your client gets financial help from friends or family"
    click_on "Back"
    confirm_screen("benefits")
    click_on "Save and continue"
    fill_in_other_income_screen
    confirm_screen("outgoings")
  end

  it "asks for employment details if I am employed" do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen
    fill_in_dependant_details_screen
    fill_in_employment_status_screen(choice: "Employed")
    fill_in_income_screen
    confirm_screen("benefits")
  end

  it "asks for benefit details if relevant" do
    allow(CfeConnection).to receive(:state_benefit_types).and_return([])

    start_assessment
    fill_in_forms_until(:benefits)
    fill_in_benefits_screen(choice: "Yes")
    fill_in_benefit_details_screen
    confirm_screen("other_income")
  end

  it "asks for property details if property owned outright" do
    start_assessment
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, owned outright")
    fill_in_property_entry_screen
    confirm_screen("additional_property")
  end

  it "asks for property details if property owned with mortgage" do
    start_assessment
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    confirm_screen("mortgage_or_loan_payment")
  end

  context "when on check answers" do
    before do
      start_assessment
      fill_in_forms_until(:vehicle)
      fill_in_vehicle_screen(choice: "Yes")
      fill_in_vehicles_details_screen
    end

    it "asks for vehicle details if vehicle owned" do
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
           "Home client lives in",
           "Housing costs",
           "Client other property",
           "Client assets",
           "Vehicles",
           "Vehicle 1 details"],
        )
    end
  end
end
