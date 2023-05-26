require "rails_helper"

RSpec.describe "partner_assets", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "controlled" }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help)
    visit "estimates/#{assessment_code}/build_estimates/partner_assets"
  end

  it "shows appropriate error messages if form left blank" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to eq [
        "Enter the estimated value of the additional property, holiday home, or land. Enter 0 if this does not apply.",
        "Enter total of all money in bank accounts. Enter 0 if this does not apply.",
        "Enter the total value of investments. Enter 0 if this does not apply.",
        "Enter the value of items worth £500 or more. Enter 0 if this does not apply.",
      ].join
    end
  end

  it "shows appropriate error messages if valuables amount too low" do
    fill_in "partner_assets_form[valuables]", with: "456"
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page.text).to include("Valuable items must be £500 or more. Enter 0 if this does not apply")
    end
  end

  it "stores the chosen values in the session" do
    fill_in "partner_assets_form[property_value]", with: "123"
    fill_in "partner_assets_form[savings]", with: "234"
    fill_in "partner_assets_form[investments]", with: "345"
    fill_in "partner_assets_form[valuables]", with: "4560"
    fill_in "partner_assets_form[property_mortgage]", with: "567"
    fill_in "partner_assets_form[property_percentage_owned]", with: "50"
    click_on "Save and continue"

    expect(session_contents["partner_property_value"]).to eq 123
    expect(session_contents["partner_savings"]).to eq 234
    expect(session_contents["partner_investments"]).to eq 345
    expect(session_contents["partner_valuables"]).to eq 4560
    expect(session_contents["partner_property_mortgage"]).to eq 567
    expect(session_contents["partner_property_percentage_owned"]).to eq 50
  end

  context "when the household flow is enabled", :household_section_flag do
    it "shows appropriate error messages if form left blank" do
      click_on "Save and continue"
      within ".govuk-error-summary__list" do
        expect(page.text).to eq [
          "Enter total of all money in bank accounts. Enter 0 if this does not apply.",
          "Enter the total value of investments. Enter 0 if this does not apply.",
          "Enter the value of items worth £500 or more. Enter 0 if this does not apply.",
        ].join
      end
    end

    it "stores the chosen values in the session" do
      fill_in "partner_assets_form[savings]", with: "234"
      fill_in "partner_assets_form[investments]", with: "345"
      fill_in "partner_assets_form[valuables]", with: "4560"
      click_on "Save and continue"

      expect(session_contents["partner_savings"]).to eq 234
      expect(session_contents["partner_investments"]).to eq 345
      expect(session_contents["partner_valuables"]).to eq 4560
    end
  end

  context "when special applicant groups enabled", :special_applicant_groups_flag, :household_section_flag do
    it "shows content about special applicants" do
      expect(page).to have_content "Partners in prison"
    end

    context "when the check is certificated" do
      let(:level_of_help) { "certificated" }

      it "shows appropriate links" do
        expect(page).to have_content "Guidance on clients with partners who are prisoners"
      end
    end
  end
end
