require "rails_helper"

RSpec.describe "partner_additional_property_details", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled", "partner" => true, "partner_additional_property_owned" => "outright" } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/partner_additional_property_details"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "additional_property_model[items][1][house_value]", with: "100,000"
    fill_in "additional_property_model[items][1][percentage_owned]", with: "10"
    click_on "Save and continue"
    stored_values = session_contents["partner_additional_properties"][0]
    expect(stored_values["house_value"]).to eq 100_000
    expect(stored_values["percentage_owned"]).to eq 10
  end

  context "when client has a mortgage" do
    let(:session) { { "level_of_help" => "controlled", "partner" => true, "partner_additional_property_owned" => "with_mortgage" } }

    before do
      fill_in "additional_property_model[items][1][house_value]", with: "100,000"
      fill_in "additional_property_model[items][1][percentage_owned]", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "additional_property_model[items][1][mortgage]", with: "50,000"
      click_on "Save and continue"

      stored_values = session_contents["partner_additional_properties"][0]
      expect(stored_values["mortgage"]).to eq 50_000
    end
  end
end
