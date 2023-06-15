require "rails_helper"

RSpec.describe "property_entry", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/property_entry"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "client-property-entry-form-house-value-field", with: "100000"
    fill_in "client-property-entry-form-percentage-owned-field", with: "10"
    check "This asset is a subject matter of dispute"
    click_on "Save and continue"

    expect(session_contents["house_value"]).to eq 100_000
    expect(session_contents["percentage_owned"]).to eq 10
    expect(session_contents["house_in_dispute"]).to eq true
  end

  context "when client has a mortgage" do
    let(:session) { { "level_of_help" => "controlled", "property_owned" => "with_mortgage" } }

    before do
      fill_in "client-property-entry-form-house-value-field", with: "100000"
      fill_in "client-property-entry-form-percentage-owned-field", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "client-property-entry-form-mortgage-field", with: "50000"
      click_on "Save and continue"

      expect(session_contents["mortgage"]).to eq 50_000
    end
  end

  it "shows SMOD checkbox" do
    expect(page).to have_content(I18n.t("generic.dispute"))
  end

  context "when this is an upper tribunal matter" do
    let(:session) { { "level_of_help" => "controlled", "immigration_or_asylum" => true } }

    it "shows no SMOD checkbox" do
      expect(page).not_to have_content(I18n.t("generic.dispute"))
    end
  end
end
