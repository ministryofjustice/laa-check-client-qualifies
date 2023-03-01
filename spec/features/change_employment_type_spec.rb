require "rails_helper"

RSpec.describe "Change employment types" do
  let(:employment_header) { "Add your client's salary breakdown" }
  let(:outgoings_header) { I18n.t("estimate_flow.outgoings.heading") }
  let(:check_answers_header) { "Check your answers" }

  it "prompts for employment (and other) questions when required" do
    visit_check_answers(passporting: true)

    within "#subsection-client_details-header" do
      click_on "Change"
    end

    select_applicant_boolean(:employed, true)
    select_applicant_boolean(:passporting, false)
    click_on "Save and continue"
    skip_dependants_form

    expect(page).to have_content employment_header
    fill_in "employment-form-gross-income-field", with: "5,000"
    fill_in "employment-form-income-tax-field", with: "1000"
    fill_in "employment-form-national-insurance-field", with: 50.5
    select_radio_value("employment-form", "frequency", :monthly)
    click_on "Save and continue"

    skip_benefits_form
    fill_incomes_screen(page:)
    click_on "Save and continue"
    expect(page).to have_content outgoings_header
    fill_outgoings_form(page:, subject: :client)
    click_on "Save and continue"
    skip_housing_form
    expect(page).to have_content check_answers_header
  end

  def skip_benefits_form
    select_boolean_value("benefits-form", :add_benefit, false)
    click_on("Save and continue")
  end

  def skip_housing_form
    fill_in "housing-form-housing-payments-value-field", with: "0"
    select_boolean_value("housing-form", :receives_housing_benefit, false)
    click_on("Save and continue")
  end
end
