require "rails_helper"

RSpec.describe "partner_outgoings", type: :feature do
  let(:assessment_code) { :assessment_code }

  before do
    visit "estimates/#{assessment_code}/build_estimates/partner_outgoings"
  end

  context "when level of help is not set" do
    it "shows default guidance text" do
      expect(page).to have_content "Guidance on outgoings"
    end
  end

  context "when level of help is explicitly 'certificated'" do
    before do
      set_session(assessment_code, { "level_of_help" => "certificated" })
      visit "estimates/#{assessment_code}/build_estimates/partner_outgoings"
    end

    it "shows default guidance text" do
      expect(page).to have_content "Guidance on outgoings"
    end
  end

  context "when level of help is explicitly 'controlled'" do
    before do
      set_session(assessment_code, { "level_of_help" => "controlled" })
      visit "estimates/#{assessment_code}/build_estimates/partner_outgoings"
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
    fill_in "partner-outgoings-form-housing-payments-value-field", with: "100"
    choose "Every month", name: "partner_outgoings_form[housing_payments_frequency]"
    fill_in "partner-outgoings-form-childcare-payments-value-field", with: "200"
    choose "Every month", name: "partner_outgoings_form[childcare_payments_frequency]"
    fill_in "partner-outgoings-form-legal-aid-payments-value-field", with: "300"
    choose "Every month", name: "partner_outgoings_form[legal_aid_payments_frequency]"
    fill_in "partner-outgoings-form-maintenance-payments-value-field", with: "400"
    choose "Every month", name: "partner_outgoings_form[maintenance_payments_frequency]"

    click_on "Save and continue"

    expect(session_contents["partner_housing_payments_value"]).to eq 100
    expect(session_contents["partner_housing_payments_frequency"]).to eq "monthly"
    expect(session_contents["partner_childcare_payments_value"]).to eq 200
    expect(session_contents["partner_childcare_payments_frequency"]).to eq "monthly"
    expect(session_contents["partner_legal_aid_payments_value"]).to eq 300
    expect(session_contents["partner_legal_aid_payments_frequency"]).to eq "monthly"
    expect(session_contents["partner_maintenance_payments_value"]).to eq 400
    expect(session_contents["partner_maintenance_payments_frequency"]).to eq "monthly"
  end
end
