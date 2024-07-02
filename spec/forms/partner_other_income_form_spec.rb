require "rails_helper"

RSpec.describe "partner_other_income", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, {})
    visit form_path(:partner_other_income, assessment_code)
  end

  it "shows error messages if form left blank" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores the chosen values in the session" do
    choose "No", name: "partner_other_income_form[friends_or_family_relevant]"
    choose "Yes", name: "partner_other_income_form[maintenance_relevant]"
    choose "Yes", name: "partner_other_income_form[property_or_lodger_relevant]"
    choose "Yes", name: "partner_other_income_form[pension_relevant]"
    choose "Yes", name: "partner_other_income_form[student_finance_relevant]"
    choose "Yes", name: "partner_other_income_form[other_relevant]"

    fill_in "partner-other-income-form-pension-conditional-value-field", with: "34"
    choose "Every month", name: "partner_other_income_form[pension_frequency]"

    fill_in "partner-other-income-form-property-or-lodger-conditional-value-field", with: "45"
    choose "Every week", name: "partner_other_income_form[property_or_lodger_frequency]"

    fill_in "partner-other-income-form-maintenance-conditional-value-field", with: "300"
    choose "Every 2 weeks", name: "partner_other_income_form[maintenance_frequency]"

    fill_in "partner-other-income-form-student-finance-conditional-value-field", with: "100"
    fill_in "partner-other-income-form-other-conditional-value-field", with: "67"

    click_on "Save and continue"

    expect(session_contents["partner_friends_or_family_relevant"]).to be false
    expect(session_contents["partner_pension_relevant"]).to be true
    expect(session_contents["partner_pension_conditional_value"]).to eq 34
    expect(session_contents["partner_pension_frequency"]).to eq "monthly"
    expect(session_contents["partner_property_or_lodger_relevant"]).to be true
    expect(session_contents["partner_property_or_lodger_conditional_value"]).to eq 45
    expect(session_contents["partner_property_or_lodger_frequency"]).to eq "every_week"
    expect(session_contents["partner_maintenance_relevant"]).to be true
    expect(session_contents["partner_maintenance_conditional_value"]).to eq 300
    expect(session_contents["partner_maintenance_frequency"]).to eq "every_two_weeks"
    expect(session_contents["partner_student_finance_relevant"]).to be true
    expect(session_contents["partner_student_finance_conditional_value"]).to eq 100
    expect(session_contents["partner_other_relevant"]).to be true
    expect(session_contents["partner_other_conditional_value"]).to eq 67
  end
end
