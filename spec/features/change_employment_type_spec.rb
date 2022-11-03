require 'rails_helper'

RSpec.describe "ChangeEmploymentTypes" do
  let(:employment_header) { "Add your client's salary breakdown" }
  let(:outgoings_header) { "What are your client's outgoings and deductions?" }
  let(:check_answers_header) { "Check your answers" }

  it "prompts for employment questions when required" do
    visit_applicant_page
    fill_in_applicant_screen_with_passporting_benefits

    click_on "Save and continue"

    complete_dependants_section
    click_checkbox("property-form-property-owned", "none")
    click_on "Save and continue"

    select_boolean_value("vehicle-form", :vehicle_owned, false)
    click_on "Save and continue"

    skip_assets_form
    within '#section-client_details-header' do
      click_on 'Change'
    end
    select_applicant_boolean(:employed, true)
    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
    expect(page).to have_content employment_header
    fill_in "employment-form-gross-income-field", with: "5,000"
    fill_in "employment-form-income-tax-field", with: "1000"
    fill_in "employment-form-national-insurance-field", with: 50.5
    click_checkbox("employment-form-frequency", :monthly)

    click_on "Save and continue"
    select_boolean_value("benefits-form", :add_benefit, false)
    click_on("Save and continue")
    click_checkbox("monthly-income-form-monthly-incomes", "none")
    click_on("Save and continue")
    expect(page).to have_content outgoings_header
    skip_outgoings_form
    expect(page).to have_content check_answers_header
  end
end
