require "rails_helper"

RSpec.describe "partner_property_entry", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "certificated" } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/partner_property_entry"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "partner-property-entry-form-house-value-field", with: "100000"
    fill_in "partner-property-entry-form-percentage-owned-field", with: "10"
    click_on "Save and continue"

    expect(session_contents["partner_house_value"]).to eq 100_000
    expect(session_contents["partner_percentage_owned"]).to eq 10
  end

  context "when partner has a mortgage" do
    let(:session) { { "level_of_help" => "certificated", "partner" => true, "partner_property_owned" => "with_mortgage" } }

    before do
      fill_in "partner-property-entry-form-house-value-field", with: "100000"
      fill_in "partner-property-entry-form-percentage-owned-field", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "partner-property-entry-form-mortgage-field", with: "50000"
      click_on "Save and continue"

      expect(session_contents["partner_mortgage"]).to eq 50_000
    end
  end
end
