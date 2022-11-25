require "rails_helper"

RSpec.describe "Partner assets page", :partner_flag do
  let(:partner_assets_heading) { I18n.t("estimate_flow.partner_assets.assets.legend") }

  before do
    visit_applicant_page_with_partner
    fill_in_applicant_screen_without_passporting_benefits
    add_applicant_partner_answers
    click_on "Save and continue"
    travel_from_dependants_to_past_client_assets
    select_boolean_value("partner-benefits-form", :add_benefit, false)
    click_on "Save and continue"
    complete_incomes_screen(subject: :partner)
    skip_outgoings_form(subject: :partner)
    select_boolean_value("partner-vehicle-form", "vehicle_owned", false)
    click_on "Save and continue"
  end

  it "shows the correct screen" do
    expect(page).to have_content(partner_assets_heading)
  end

  context "when I omit some required information" do
    before do
      click_on "Save and continue"
    end

    it "shows me an error message" do
      expect(page).to have_content partner_assets_heading
      expect(page).to have_content "Please enter the total of your client's partner's valuables"
    end
  end

  context "when I provide all required information" do
    before do
      fill_in "partner-assets-form-savings-field", with: "0"
      fill_in "partner-assets-form-investments-field", with: "0"
      fill_in "partner-assets-form-valuables-field", with: "0"
      fill_in "partner-assets-form-property-value-field", with: "80_000"
      fill_in "partner-assets-form-property-mortgage-field", with: "40_000"
      fill_in "partner-assets-form-property-percentage-owned-field", with: "50"
    end

    it "Moves me on to the next question and stores my answers" do
      prev_path = current_path
      click_on "Save and continue"
      expect(page).not_to have_content partner_assets_heading
      visit prev_path
      expect(find("#partner-assets-form-property-percentage-owned-field").value).to eq "50"
    end
  end
end
