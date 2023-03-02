require "rails_helper"

RSpec.describe "outgoings", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/outgoings"
  end

  context "when level of help is not set" do
    it "shows default guidance text" do
      expect(page).to have_content "Guidance on outgoings"
    end
  end

  context "when level of help is explicitly 'certificated'" do
    before do
      set_session(assessment_code, { "level_of_help" => "certificated" })
      visit "estimates/#{assessment_code}/build_estimates/outgoings"
    end

    it "shows default guidance text" do
      expect(page).to have_content "Guidance on outgoings"
    end
  end

  context "when level of help is explicitly 'controlled'" do
    before do
      set_session(assessment_code, { "level_of_help" => "controlled" })
      visit "estimates/#{assessment_code}/build_estimates/outgoings"
    end

    it "shows alternative guidance" do
      expect(page).to have_content "Guidance on determining disposable income"
    end
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    fill_in "outgoings-form-housing-payments-value-field", with: "100"
    choose "Every month", name: "outgoings_form[housing_payments_frequency]"
    fill_in "outgoings-form-childcare-payments-value-field", with: "200"
    choose "Every month", name: "outgoings_form[childcare_payments_frequency]"
    fill_in "outgoings-form-legal-aid-payments-value-field", with: "300"
    choose "Every month", name: "outgoings_form[legal_aid_payments_frequency]"
    fill_in "outgoings-form-maintenance-payments-value-field", with: "400"
    choose "Every month", name: "outgoings_form[maintenance_payments_frequency]"

    click_on "Save and continue"

    expect(session_contents["housing_payments_value"]).to eq 100
    expect(session_contents["housing_payments_frequency"]).to eq "monthly"
    expect(session_contents["childcare_payments_value"]).to eq 200
    expect(session_contents["childcare_payments_frequency"]).to eq "monthly"
    expect(session_contents["legal_aid_payments_value"]).to eq 300
    expect(session_contents["legal_aid_payments_frequency"]).to eq "monthly"
    expect(session_contents["maintenance_payments_value"]).to eq 400
    expect(session_contents["maintenance_payments_frequency"]).to eq "monthly"
  end
end
