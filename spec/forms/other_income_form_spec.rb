require "rails_helper"

RSpec.describe "other_income", :stub_cfe_calls, type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:feature_flags) { {} }

  before do
    set_session(assessment_code, "level_of_help" => "controlled", "feature_flags" => feature_flags)
    visit form_path(:other_income, assessment_code)
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

  context "when conditional reveals are enabled" do
    let(:feature_flags) { { "conditional_reveals" => true } }

    it "shows error messages if radios left blank" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
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

      expect(session_contents["friends_or_family_relevant"]).to eq false
      expect(session_contents["maintenance_relevant"]).to eq true
      expect(session_contents["maintenance_conditional_value"]).to eq 300
      expect(session_contents["maintenance_frequency"]).to eq "every_two_weeks"
      expect(session_contents["property_or_lodger_relevant"]).to eq true
      expect(session_contents["property_or_lodger_conditional_value"]).to eq 45
      expect(session_contents["property_or_lodger_frequency"]).to eq "every_week"
      expect(session_contents["pension_relevant"]).to eq true
      expect(session_contents["pension_conditional_value"]).to eq 34
      expect(session_contents["pension_frequency"]).to eq "monthly"
      expect(session_contents["student_finance_relevant"]).to eq true
      expect(session_contents["student_finance_conditional_value"]).to eq 100
      expect(session_contents["other_relevant"]).to eq true
      expect(session_contents["other_conditional_value"]).to eq 67
    end
  end
end
