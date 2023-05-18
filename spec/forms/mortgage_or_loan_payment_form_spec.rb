require "rails_helper"

RSpec.describe "mortgage_or_loan_payment", type: :feature do
  let(:assessment_code) { :assessment_code }
  let(:session) { { "level_of_help" => "controlled" } }

  before do
    set_session(assessment_code, session)
    visit "estimates/#{assessment_code}/build_estimates/mortgage_or_loan_payment"
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my housing payments responses in the session" do
    fill_in "mortgage-or-loan-payment-form-housing-payments-field", with: "1000"
    choose "Every month"
    click_on "Save and continue"

    expect(session_contents["housing_payments"]).to eq 1000
    expect(session_contents["housing_payments_frequency"]).to eq "monthly"
  end
end
