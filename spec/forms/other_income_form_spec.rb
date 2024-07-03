require "rails_helper"

RSpec.describe "other_income", :stub_cfe_calls, type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    set_session(assessment_code, "level_of_help" => "controlled")
    visit form_path(:other_income, assessment_code)
  end

  def answer_no_for_previous_fields
    choose "No", name: "other_income_form[friends_or_family_relevant]"
    choose "No", name: "other_income_form[maintenance_relevant]"
    choose "No", name: "other_income_form[property_or_lodger_relevant]"
    choose "No", name: "other_income_form[pension_relevant]"
    choose "No", name: "other_income_form[student_finance_relevant]"
  end

  it "shows error messages if radios left blank" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "shows custom error messages for blank other value" do
    answer_no_for_previous_fields
    choose "Yes", name: "other_income_form[other_relevant]"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    expect(page).to have_content("Enter amount of income from other sources received")
  end

  it "shows custom error messages for other value less than 0" do
    answer_no_for_previous_fields
    choose "Yes", name: "other_income_form[other_relevant]"
    fill_in "other-income-form-other-conditional-value-field", with: "0"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    expect(page).to have_content("Amount of income from other sources received in the last month must be more than 0")
  end

  it "shows custom error messages for non-numeric other value" do
    answer_no_for_previous_fields
    choose "Yes", name: "other_income_form[other_relevant]"
    fill_in "other-income-form-other-conditional-value-field", with: "pikachu"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    expect(page).to have_content("Amount of income from other sources received in the last month must be a number")
  end

  it "stores the chosen values in the session" do
    choose "No", name: "other_income_form[friends_or_family_relevant]"
    choose "Yes", name: "other_income_form[maintenance_relevant]"
    choose "Yes", name: "other_income_form[property_or_lodger_relevant]"
    choose "Yes", name: "other_income_form[pension_relevant]"
    choose "Yes", name: "other_income_form[student_finance_relevant]"
    choose "Yes", name: "other_income_form[other_relevant]"

    fill_in "other-income-form-maintenance-conditional-value-field", with: "300"
    choose "Every 2 weeks", name: "other_income_form[maintenance_frequency]"

    fill_in "other-income-form-property-or-lodger-conditional-value-field", with: "45"
    choose "Every week", name: "other_income_form[property_or_lodger_frequency]"

    fill_in "other-income-form-pension-conditional-value-field", with: "34"
    choose "Every month", name: "other_income_form[pension_frequency]"

    fill_in "other-income-form-student-finance-conditional-value-field", with: "100"

    fill_in "other-income-form-other-conditional-value-field", with: "67"

    click_on "Save and continue"

    expect(session_contents["friends_or_family_relevant"]).to be false
    expect(session_contents["maintenance_relevant"]).to be true
    expect(session_contents["maintenance_conditional_value"]).to eq 300
    expect(session_contents["maintenance_frequency"]).to eq "every_two_weeks"
    expect(session_contents["property_or_lodger_relevant"]).to be true
    expect(session_contents["property_or_lodger_conditional_value"]).to eq 45
    expect(session_contents["property_or_lodger_frequency"]).to eq "every_week"
    expect(session_contents["pension_relevant"]).to be true
    expect(session_contents["pension_conditional_value"]).to eq 34
    expect(session_contents["pension_frequency"]).to eq "monthly"
    expect(session_contents["student_finance_relevant"]).to be true
    expect(session_contents["student_finance_conditional_value"]).to eq 100
    expect(session_contents["other_relevant"]).to be true
    expect(session_contents["other_conditional_value"]).to eq 67
  end
end
