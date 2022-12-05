require "rails_helper"

RSpec.describe "Partner vehicle pages", :partner_flag do
  let(:partner_vehicle_heading) { I18n.t("estimate_flow.partner_vehicle.vehicle_owned.legend") }
  let(:partner_vehicle_details_heading) { I18n.t("estimate_flow.partner_vehicle_details.heading") }

  before do
    visit_applicant_page
    fill_in_applicant_screen_without_passporting_benefits
    click_on "Save and continue"
    travel_from_housing_benefit_to_past_client_assets
    select_boolean_value("partner-details-form", :over_60, false)
    select_boolean_value("partner-details-form", :employed, false)
    click_on "Save and continue"
    skip_partner_dependants_form
    select_boolean_value("partner-housing-benefit-form", :housing_benefit, false)
    click_on("Save and continue")
    select_boolean_value("partner-benefits-form", :add_benefit, false)
    click_on "Save and continue"
    complete_incomes_screen(subject: :partner)
    skip_outgoings_form(subject: :partner)
    skip_partner_property_form
  end

  it "shows the correct screen" do
    expect(page).to have_content(partner_vehicle_heading)
  end

  context "when I omit to answer" do
    before do
      click_on "Save and continue"
    end

    it "shows me an error message" do
      expect(page).to have_content partner_vehicle_heading
      expect(page).to have_content "Select yes if the client's partner owns a vehicle"
    end
  end

  context "when I answer the first question with a yes" do
    before do
      select_boolean_value("partner-vehicle-form", "vehicle_owned", true)
      click_on "Save and continue"
    end

    it "Moves me on to the next question and stores my answers" do
      expect(page).to have_content partner_vehicle_details_heading
    end

    it "Shows an error if I leave out answers" do
      click_on "Save and continue"
      expect(page).to have_content partner_vehicle_details_heading
      expect(page).to have_content "Please enter the estimated value"
    end

    it "Allows me to proceed if I enter answers" do
      fill_in "partner-vehicle-details-form-vehicle-value-field", with: "5000"
      select_boolean_value("partner-vehicle-details-form", :vehicle_in_regular_use, false)
      select_boolean_value("partner-vehicle-details-form", :vehicle_pcp, false)
      select_boolean_value("partner-vehicle-details-form", :vehicle_over_3_years_ago, true)
      click_on "Save and continue"
      expect(page).not_to have_content partner_vehicle_details_heading
    end
  end

  context "when I answer the first question with a no" do
    before do
      select_boolean_value("partner-vehicle-form", "vehicle_owned", false)
      click_on "Save and continue"
    end

    it "Skips the details" do
      expect(page).not_to have_content partner_vehicle_details_heading
    end
  end
end
