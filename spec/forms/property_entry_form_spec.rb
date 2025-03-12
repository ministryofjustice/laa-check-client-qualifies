require "rails_helper"

RSpec.describe "property_entry", :calls_cfe_early_returns_not_ineligible, type: :feature do
  let(:property_owned) { "Yes, owned outright" }
  let(:immigration_or_asylum) { false }
  let(:partner) { false }

  before do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")

    if immigration_or_asylum
      fill_in_forms_until(:immigration_or_asylum)
      fill_in_immigration_or_asylum_screen(choice: "Yes")
    end

    fill_in_forms_until(:applicant)
    if partner
      fill_in_applicant_screen(partner: "Yes")
    else
      fill_in_applicant_screen(partner: "No")
    end

    fill_in_forms_until(:property)
    fill_in_property_screen(choice: property_owned)
  end

  it "stores my responses in the session" do
    fill_in "property-entry-form-house-value-field", with: "100000"
    fill_in "property-entry-form-percentage-owned-field", with: "10"
    check "This asset is a subject matter of dispute"
    click_on "Save and continue"

    expect(session_contents["house_value"]).to eq 100_000
    expect(session_contents["percentage_owned"]).to eq 10
    expect(session_contents["house_in_dispute"]).to be true
  end

  context "when client has a mortgage" do
    let(:property_owned) { "Yes, with a mortgage or loan" }

    before do
      fill_in_mortgage_or_loan_payment_screen
      fill_in "property-entry-form-house-value-field", with: "100000"
      fill_in "property-entry-form-percentage-owned-field", with: "10"
    end

    it "allows me to specify mortgage size" do
      fill_in "property-entry-form-mortgage-field", with: "50000"
      click_on "Save and continue"

      expect(session_contents["mortgage"]).to eq 50_000
    end
  end

  it "shows SMOD checkbox" do
    expect(page).to have_content(I18n.t("generic.dispute"))
  end

  context "when this is an upper tribunal matter" do
    let(:immigration_or_asylum) { true }

    it "shows no SMOD checkbox" do
      expect(page).not_to have_content(I18n.t("generic.dispute"))
    end
  end

  context "when MTR accelerated takes effect" do
    context "when single" do
      it "shows new content" do
        expect(page).to have_content("The home your client usually lives in")
      end
    end

    context "with partner" do
      let(:partner) { true }

      context "with MTR accelerated" do
        it "shows new content" do
          expect(page).to have_content("Your client or their partner’s name must be on the property deeds, lease, freehold or mortgage.")
        end
      end
    end

    context "when going to check_answers" do
      before do
        fill_in_forms_until(:check_answers)
      end

      context "with MTR accelerated" do
        it "shows new content" do
          expect(page).to have_content("Does your client own the home the client usually lives in?")
          expect(page).to have_content("Home client lives in equity")
        end
      end
    end
  end
end
