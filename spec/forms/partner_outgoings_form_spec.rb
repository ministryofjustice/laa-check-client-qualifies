require "rails_helper"

RSpec.describe "partner_outgoings", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:level_of_help) { "certificated" }
  let(:childcare_payments) { "Does the partner pay for childcare?" }

  before do
    set_session(assessment_code, { "level_of_help" => level_of_help })
    visit form_path(:partner_outgoings, assessment_code)
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

  it "stores my values correctly" do
    choose "No", name: "partner_outgoings_form[legal_aid_payments_relevant]"
    choose "Yes", name: "partner_outgoings_form[maintenance_payments_relevant]"

    fill_in "partner-outgoings-form-maintenance-payments-conditional-value-field", with: "400"
    choose "Every month", name: "partner_outgoings_form[maintenance_payments_frequency]"

    click_on "Save and continue"

    expect(session_contents["partner_legal_aid_payments_relevant"]).to eq false
    expect(session_contents["partner_maintenance_payments_conditional_value"]).to eq 400
    expect(session_contents["partner_maintenance_payments_frequency"]).to eq "monthly"
  end

  it "does not show childcare costs question" do
    expect(page).not_to have_text(childcare_payments)
  end

  context "when client is eligible for childcare costs" do
    before do
      allow(ChildcareEligibilityService).to receive(:call).and_return true
      visit form_path(:partner_outgoings, assessment_code)
    end

    it "shows childcare costs question" do
      expect(page).to have_text(childcare_payments)
    end
  end
end
