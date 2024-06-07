require "rails_helper"

RSpec.describe "mortgage_or_loan_payment", type: :feature do
  let(:content_date) { Time.zone.today }

  before do
    travel_to content_date
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
    let(:before_date) { Date.new(2023, 2, 15) }
    let(:after_date) { Date.new(2024, 7, 15) }

    context "without MTR accelerated" do
      let(:content_date) { before_date }

      it "shows old content" do
        expect(page).to have_content("What are the mortgage or loan payments for the home your client live")
      end
    end

    context "with MTR accelerated", :mtr_accelerated_flag do
      let(:content_date) { after_date }

      it "shows new content" do
        expect(page).to have_content("What are the mortgage or loan payments for the home your client usually lives in?")
      end
    end

    context "when going to check_answers" do
      before do
        fill_in_forms_until(:check_answers)
      end

      context "without MTR accelerated" do
        let(:content_date) { before_date }

        it "shows old content" do
          expect(page).to have_content("What are the mortgage or loan payments for the home the client lives in?")
        end
      end

      context "with MTR accelerated", :mtr_accelerated_flag do
        let(:content_date) { after_date }

        it "shows new content" do
          expect(page).to have_content("What are the mortgage or loan payments for the home the client usually lives in?")
        end
      end
    end
  end
end
