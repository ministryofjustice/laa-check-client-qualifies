require "rails_helper"

RSpec.describe "housing_costs", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session)
    visit form_path(:housing_costs, assessment_code)
  end

  it "performs validations if I leave the field blank" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "performs validations if I enter invalid values" do
    fill_in "housing-costs-form-housing-payments-field", with: "1 1"
    choose "Every 2 weeks", name: "housing_costs_form[housing_payments_frequency]"
    fill_in "housing-costs-form-housing-benefit-value-field", with: "40"
    choose "Every 4 weeks", name: "housing_costs_form[housing_benefit_frequency]"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my housing payments responses in the session" do
    fill_in "housing-costs-form-housing-payments-field", with: "20"
    choose "Every 2 weeks", name: "housing_costs_form[housing_payments_frequency]"
    fill_in "housing-costs-form-housing-benefit-value-field", with: "40"
    choose "Every 4 weeks", name: "housing_costs_form[housing_benefit_frequency]"
    click_on "Save and continue"

    expect(session_contents["housing_payments"]).to eq 20
    expect(session_contents["housing_payments_frequency"]).to eq "every_two_weeks"
    expect(session_contents["housing_benefit_value"]).to eq 40
    expect(session_contents["housing_benefit_frequency"]).to eq "every_four_weeks"
  end

  it "detects if benefit exceeds costs" do
    fill_in "housing-costs-form-housing-payments-field", with: "20"
    choose "Every week", name: "housing_costs_form[housing_payments_frequency]"
    fill_in "housing-costs-form-housing-benefit-value-field", with: "400"
    choose "Every month", name: "housing_costs_form[housing_benefit_frequency]"
    click_on "Save and continue"

    expect(page).to have_text "Housing benefit cannot be higher than housing costs"
  end

  context "when the level of help is certificated" do
    let(:session) { { "level_of_help" => "certificated" } }

    it "shows 'Total in last 3 months' radio" do
      fill_in "housing-costs-form-housing-payments-field", with: "2000"
      choose "Total in last 3 months", name: "housing_costs_form[housing_payments_frequency]"
      fill_in "housing-costs-form-housing-benefit-value-field", with: "40"
      choose "Every 2 weeks", name: "housing_costs_form[housing_benefit_frequency]"
      click_on "Save and continue"

      expect(session_contents["housing_payments_frequency"]).to eq "total"
    end
  end
end
