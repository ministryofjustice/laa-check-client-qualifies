require "rails_helper"

RSpec.describe "shared_ownership_housing_costs", :calls_cfe_early_returns_not_ineligible, :shared_ownership, type: :feature do
  let(:level_of_help) { :controlled }

  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "No", passporting: "No")
    fill_in_dependant_details_screen
    fill_in_employment_status_screen
    fill_in_benefits_screen
    fill_in_other_income_screen
    fill_in_outgoings_screen
    fill_in_property_screen(choice: "Yes, through a shared ownership scheme")
    fill_in_property_landlord_screen
  end

  it "performs validations if I enter invalid values" do
    fill_in "shared-ownership-housing-costs-form-rent-field", with: "1 1"
    choose "Every 2 weeks", name: "shared_ownership_housing_costs_form[combined_frequency]"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    expect(page).to have_content("Select yes if your client gets Housing Benefit for this home")
  end

  it "stores my shared ownership housing payments responses in the session" do
    fill_in "shared-ownership-housing-costs-form-rent-field", with: "200"
    choose "Every 2 weeks", name: "shared_ownership_housing_costs_form[combined_frequency]"
    choose "Yes", name: "shared_ownership_housing_costs_form[housing_benefit_relevant]"
    fill_in "shared-ownership-housing-costs-form-housing-benefit-value-field", with: "150"
    choose "Every 4 weeks", name: "shared_ownership_housing_costs_form[housing_benefit_frequency]"
    fill_in "shared-ownership-housing-costs-form-shared-ownership-mortgage-field", with: "123"
    click_on "Save and continue"

    expect(session_contents["rent"]).to eq 200
    expect(session_contents["combined_frequency"]).to eq "every_two_weeks"
    expect(session_contents["housing_benefit_value"]).to eq 150
    expect(session_contents["housing_benefit_frequency"]).to eq "every_four_weeks"
    expect(session_contents["shared_ownership_mortgage"]).to eq 123
  end
end
