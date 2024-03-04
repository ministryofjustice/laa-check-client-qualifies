require "rails_helper"

RSpec.describe "outgoings", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }
  let(:childcare_payments) { "Childcare payments" }
  let(:feature_flags) { {} }

  before do
    set_session(assessment_code, "level_of_help" => level_of_help, "feature_flags" => feature_flags)
    visit form_path(:outgoings, assessment_code)
  end

  context "when level of help is 'certificated'" do
    it "shows default guidance text" do
      expect(page).to have_content "Determining outgoings"
    end
  end

  context "when level of help is 'controlled'" do
    let(:level_of_help) { "controlled" }

    it "shows alternative guidance" do
      expect(page).to have_content "Determining disposable income"
    end
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "outgoings-form-legal-aid-payments-value-field", with: "300"
    choose "Every month", name: "outgoings_form[legal_aid_payments_frequency]"
    fill_in "outgoings-form-maintenance-payments-value-field", with: "400"
    choose "Every month", name: "outgoings_form[maintenance_payments_frequency]"

    click_on "Save and continue"

    expect(session_contents["legal_aid_payments_value"]).to eq 300
    expect(session_contents["legal_aid_payments_frequency"]).to eq "monthly"
    expect(session_contents["maintenance_payments_value"]).to eq 400
    expect(session_contents["maintenance_payments_frequency"]).to eq "monthly"
  end

  it "does not show childcare costs question" do
    expect(page).not_to have_text(childcare_payments)
  end

  context "when client is eligible for childcare costs" do
    before do
      allow(ChildcareEligibilityService).to receive(:call).and_return true
      visit form_path(:outgoings, assessment_code)
    end

    it "shows childcare costs question" do
      expect(page).to have_text(childcare_payments)
    end

    it "stores my responses in the session" do
      fill_in "outgoings-form-childcare-payments-value-field", with: "200"
      choose "Every month", name: "outgoings_form[childcare_payments_frequency]"
      fill_in "outgoings-form-legal-aid-payments-value-field", with: "0"
      fill_in "outgoings-form-maintenance-payments-value-field", with: "0"

      click_on "Save and continue"

      expect(session_contents["childcare_payments_value"]).to eq 200
      expect(session_contents["childcare_payments_frequency"]).to eq "monthly"
    end
  end

  context "when conditional reveals are enabled" do
    let(:feature_flags) { { "conditional_reveals" => true } }

    it "shows error messages if radios left blank" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
    end

    it "stores the chosen values in the session" do
      choose "No", name: "outgoings_form[legal_aid_payments_relevant]"
      choose "Yes", name: "outgoings_form[maintenance_payments_relevant]"

      fill_in "outgoings-form-maintenance-payments-conditional-value-field", with: "300"
      choose "Every 2 weeks", name: "outgoings_form[maintenance_payments_frequency]"

      click_on "Save and continue"

      expect(session_contents["legal_aid_payments_relevant"]).to eq false
      expect(session_contents["maintenance_payments_relevant"]).to eq true
      expect(session_contents["maintenance_payments_conditional_value"]).to eq 300
      expect(session_contents["maintenance_payments_frequency"]).to eq "every_two_weeks"
    end
  end
end
