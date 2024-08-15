require "rails_helper"

RSpec.describe "outgoings flow", :stub_cfe_calls_with_webmock, type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner:, passporting:)
  end

  context "when there is no partner and passported" do
    let(:partner) { "No" }
    let(:passporting) { "Yes" }

    before do
      fill_in_property_screen(choice: "Yes, with a mortgage or loan")
      fill_in_property_entry_screen
      fill_in_additional_property_screen(choice: "Yes, owned outright")
      fill_in_additional_property_details_screen
      fill_in_assets_screen
      fill_in_vehicle_screen(choice: "Yes")
      fill_in_vehicles_details_screen
    end

    it "shows screens" do
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
           "Home client lives in",
           "Housing costs",
           "Home client lives in details",
           "Client other property",
           "Client other property 1 details",
           "Client assets",
           "Vehicles",
           "Vehicle 1 details"],
        )
    end
  end

  context "when there is a partner and passported" do
    let(:partner) { "Yes" }
    let(:passporting) { "Yes" }

    before do
      fill_in_partner_details_screen
      fill_in_property_screen(choice: "No")
      fill_in_additional_property_screen(choice: "No")
      fill_in_partner_additional_property_screen(choice: "Yes, owned outright")
      fill_in_partner_additional_property_details_screen
      fill_in_assets_screen
      fill_in_partner_assets_screen
      fill_in_vehicle_screen
    end

    it "shows screens" do
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
           "Partner age",
           "Home client lives in",
           "Housing costs",
           "Client other property",
           "Partner other property",
           "Partner other property 1 details",
           "Client assets",
           "Partner assets",
           "Vehicles"],
        )
    end
  end

  context "when there is no partner and not passported" do
    let(:partner) { "No" }
    let(:passporting) { "No" }

    before do
      fill_in_forms_until(:outgoings)
      fill_in_outgoings_screen
      fill_in_property_screen
      fill_in_housing_costs_screen
      fill_in_additional_property_screen
      fill_in_assets_screen
      fill_in_vehicle_screen
    end

    it "shows screens" do
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

  context "when there is a partner and not passported" do
    let(:partner) { "Yes" }
    let(:passporting) { "No" }

    before do
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
    end

    it "shows screens" do
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
           "Home client lives in",
           "Housing costs",
           "Home client lives in details",
           "Client other property",
           "Partner other property",
           "Client assets",
           "Partner assets",
           "Vehicles"],
        )
    end
  end
end
