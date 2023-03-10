require "rails_helper"

RSpec.describe "assets", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/assets"
  end

  it "shows appropriate error messages if form left blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Enter the estimated value of the additional property, holiday home, or land, if this does not apply enter 0",
        "Enter the total amount of all savings. Enter 0 if this does not apply.",
        "Enter the total value of investments, if this does not apply enter 0",
        "Enter the total value of items worth £500 or more. Enter 0 if this does not apply.",
      ].join
    end
  end

  it "shows appropriate error messages if valuables amount too low" do
    fill_in "client_assets_form[valuables]", with: "456"
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to include("Valuable items must be £500 or more, if this does not apply enter 0")
    end
  end

  it "stores the chosen values in the session" do
    fill_in "client_assets_form[property_value]", with: "123"
    fill_in "client_assets_form[savings]", with: "234"
    fill_in "client_assets_form[investments]", with: "345"
    fill_in "client_assets_form[valuables]", with: "4560"
    fill_in "client_assets_form[property_mortgage]", with: "567"
    fill_in "client_assets_form[property_percentage_owned]", with: "50"
    check("client-assets-form-in-dispute-property-field")
    click_on "Save and continue"

    expect(session_contents["property_value"]).to eq 123
    expect(session_contents["savings"]).to eq 234
    expect(session_contents["investments"]).to eq 345
    expect(session_contents["valuables"]).to eq 4560
    expect(session_contents["property_mortgage"]).to eq 567
    expect(session_contents["property_percentage_owned"]).to eq 50
    expect(session_contents["in_dispute"]).to eq %w[property]
  end
end
