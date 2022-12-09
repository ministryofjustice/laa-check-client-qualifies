require "rails_helper"

RSpec.describe "Partner assets page", :partner_flag do
  let(:partner_assets_heading) { I18n.t("estimate_flow.partner_assets.assets.legend") }

  before do
    visit_flow_page(passporting: false, partner: true, target: :partner_assets)
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
    end
  end

  context "when I provide all required information" do
    before do
      fill_in "partner-assets-form-savings-field", with: "0"
      fill_in "partner-assets-form-investments-field", with: "0"
      fill_in "partner-assets-form-valuables-field", with: "0"
      fill_in "partner-assets-form-property-value-field", with: "80,000"
      fill_in "partner-assets-form-property-mortgage-field", with: "40,000"
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
