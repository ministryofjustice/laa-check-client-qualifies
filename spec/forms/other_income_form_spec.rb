require "rails_helper"

RSpec.describe "other_income", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/other_income"
  end

  it "shows error messages if form left blank" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores the chosen values in the session" do
    fill_in "other-income-form-pension-value-field", with: "34"
    choose "Every month", name: "other_income_form[pension_frequency]"

    fill_in "other-income-form-property-or-lodger-value-field", with: "45"
    choose "Every week", name: "other_income_form[property_or_lodger_frequency]"

    fill_in "other-income-form-friends-or-family-value-field", with: "200"
    choose "Every week", name: "other_income_form[friends_or_family_frequency]"

    fill_in "other-income-form-maintenance-value-field", with: "300"
    choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

    fill_in "other-income-form-student-finance-value-field", with: "100"
    fill_in "other-income-form-other-value-field", with: "67"

    click_on "Save and continue"

    expect(session_contents["pension_value"]).to eq 34
    expect(session_contents["pension_frequency"]).to eq "monthly"
    expect(session_contents["property_or_lodger_value"]).to eq 45
    expect(session_contents["property_or_lodger_frequency"]).to eq "every_week"
    expect(session_contents["friends_or_family_value"]).to eq 200
    expect(session_contents["friends_or_family_frequency"]).to eq "every_week"
    expect(session_contents["maintenance_value"]).to eq 300
    expect(session_contents["maintenance_frequency"]).to eq "every_two_weeks"
    expect(session_contents["student_finance_value"]).to eq 100
    expect(session_contents["other_value"]).to eq 67
  end
end
