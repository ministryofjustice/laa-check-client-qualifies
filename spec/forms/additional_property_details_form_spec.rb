require "rails_helper"

RSpec.describe "additional_property_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled", "additional_property_owned" => "outright" } }

  before do
    set_session(assessment_code, session)
    visit form_path(:additional_property_details, assessment_code)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "additional_property_model[items][1][house_value]", with: "100,000"
    fill_in "additional_property_model[items][1][percentage_owned]", with: "10"
    check "This asset is a subject matter of dispute", name: "additional_property_model[items][1][house_in_dispute]"
    click_on "Save and continue"
    stored_values = session_contents["additional_properties"][0]
    expect(stored_values["house_value"]).to eq 100_000
    expect(stored_values["percentage_owned"]).to eq 10
    expect(stored_values["house_in_dispute"]).to eq true
  end

  context "when client has a partner" do
    let(:session) { { "level_of_help" => "controlled", "partner" => true } }
    let(:partner_hint_text) { I18n.t("estimate_flow.additional_property_details.hint") }

    it "adds some relevant hint text" do
      expect(page).to have_content partner_hint_text
    end
  end

  context "when client has a mortgage" do
    let(:session) { { "level_of_help" => "controlled", "additional_property_owned" => "with_mortgage" } }

    before do
      fill_in "additional_property_model[items][1][house_value]", with: "100,000"
      fill_in "additional_property_model[items][1][percentage_owned]", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "additional_property_model[items][1][mortgage]", with: "50,000"
      click_on "Save and continue"

      stored_values = session_contents["additional_properties"][0]
      expect(stored_values["mortgage"]).to eq 50_000
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
