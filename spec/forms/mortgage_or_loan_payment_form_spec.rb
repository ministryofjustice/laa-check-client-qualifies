require "rails_helper"

RSpec.describe "mortgage_or_loan_payment", :calls_cfe_early_returns_not_ineligible, type: :feature do
  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
    fill_in_forms_until(:property)
    fill_in_property_screen(choice: "Yes, with a mortgage or loan")
    fill_in_forms_until(:mortgage_or_loan_payment)
  end

  it "stores my housing payments responses in the session" do
    fill_in "mortgage-or-loan-payment-form-housing-loan-payments-field", with: "1000"
    choose "Every month"
    click_on "Save and continue"

    expect(session_contents["housing_loan_payments"]).to eq 1000
    expect(session_contents["housing_payments_loan_frequency"]).to eq "monthly"
  end

  it "allows me to enter 0" do
    fill_in "mortgage-or-loan-payment-form-housing-loan-payments-field", with: "0"
    click_on "Save and continue"

    expect(session_contents["housing_loan_payments"]).to eq 0
  end

  context "when MTR accelerated is in effect" do
    it "shows new content" do
      expect(page).to have_content("What are the mortgage or loan payments for the home your client usually lives in?")
    end
  end

  context "when going to check_answers" do
    before do
      fill_in_forms_until(:check_answers)
    end

    context "with MTR accelerated" do
      it "shows new content" do
        expect(page).to have_content("What are the mortgage or loan payments for the home the client usually lives in?")
      end

      it "shows correct sections" do
        expect(all(".govuk-summary-card__title").map(&:text))
          .to eq(
            ["Client age",
             "Partner and passporting",
             "Level of help",
             "Type of matter",
             "Number of dependants",
             "Employment status",
             "Client benefits",
             "Client other income",
             "Client outgoings and deductions",
             "Home client usually lives in",
             "Housing costs",
             "Home client lives in equity",
             "Client other property",
             "Client assets"],
          )
      end
    end
  end
end
