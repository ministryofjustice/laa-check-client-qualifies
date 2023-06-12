require "rails_helper"

RSpec.describe "partner_additional_property_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/partner_additional_property_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "partner-additional-property-details-form-house-value-field", with: "100000"
    fill_in "partner-additional-property-details-form-percentage-owned-field", with: "10"
    click_on "Save and continue"

    expect(session_contents["partner_additional_house_value"]).to eq 100_000
    expect(session_contents["partner_additional_percentage_owned"]).to eq 10
  end

  context "when client has a partner" do
    let(:session) { { "level_of_help" => "controlled", "partner" => true } }
    let(:partner_hint_text) { I18n.t("estimate_flow.partner_additional_property_details.hint") }

    it "adds some relevant hint text" do
      expect(page).to have_content partner_hint_text
    end
  end

  context "when client has a mortgage" do
    let(:session) { { "level_of_help" => "controlled", "partner" => true, "partner_additional_property_owned" => "with_mortgage" } }

    before do
      fill_in "partner-additional-property-details-form-house-value-field", with: "100000"
      fill_in "partner-additional-property-details-form-percentage-owned-field", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "partner-additional-property-details-form-mortgage-field", with: "50000"
      click_on "Save and continue"

      expect(session_contents["partner_additional_mortgage"]).to eq 50_000
    end
  end
end
