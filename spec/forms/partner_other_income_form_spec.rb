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
    fill_in "partner-other-income-form-pension-value-field", with: "34"
    choose "Every month", name: "partner_other_income_form[pension_frequency]"

    fill_in "partner-other-income-form-property-or-lodger-value-field", with: "45"
    choose "Every week", name: "partner_other_income_form[property_or_lodger_frequency]"

    fill_in "partner-other-income-form-friends-or-family-value-field", with: "200"
    choose "Every week", name: "partner_other_income_form[friends_or_family_frequency]"

    fill_in "partner-other-income-form-maintenance-value-field", with: "300"
    choose "Every 2 weeks", name: "partner_other_income_form[maintenance_frequency]"

    fill_in "partner-other-income-form-student-finance-value-field", with: "100"
    fill_in "partner-other-income-form-other-value-field", with: "67"

    click_on "Save and continue"

    expect(session_contents["partner_pension_value"]).to eq 34
    expect(session_contents["partner_pension_frequency"]).to eq "monthly"
    expect(session_contents["partner_property_or_lodger_value"]).to eq 45
    expect(session_contents["partner_property_or_lodger_frequency"]).to eq "every_week"
    expect(session_contents["partner_friends_or_family_value"]).to eq 200
    expect(session_contents["partner_friends_or_family_frequency"]).to eq "every_week"
    expect(session_contents["partner_maintenance_value"]).to eq 300
    expect(session_contents["partner_maintenance_frequency"]).to eq "every_two_weeks"
    expect(session_contents["partner_student_finance_value"]).to eq 100
    expect(session_contents["partner_other_value"]).to eq 67
  end
end
