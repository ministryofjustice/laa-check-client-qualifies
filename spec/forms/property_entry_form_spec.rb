require "rails_helper"

RSpec.describe "property_entry", :might_call_cfe, type: :feature do
  let(:property_owned) { "Yes, owned outright" }
  let(:immigration_or_asylum) { false }
  let(:partner) { false }
  let(:content_date) { Time.zone.today }

  before do
    travel_to content_date
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

  context "when MTR accelerated is in effect" do
    let(:before_date) { Date.new(2023, 2, 15) }
    let(:after_date) { Date.new(2024, 7, 15) }

    context "when single" do
      context "without MTR accelerated" do
        let(:content_date) { before_date }

        it "shows old content" do
          expect(page).to have_content("The home your client lives in")
        end
      end

      context "with MTR accelerated", :mtr_accelerated_flag do
        let(:content_date) { after_date }

        it "shows new content" do
          expect(page).to have_content("The home your client usually lives in")
        end
      end
    end

    context "with partner" do
      let(:partner) { true }

      context "without MTR accelerated" do
        let(:content_date) { before_date }

        it "shows old content" do
          expect(page).to have_content("former matrimonial home because of domestic abuse")
        end
      end

      context "with MTR accelerated", :mtr_accelerated_flag do
        let(:content_date) { after_date }

        it "shows new content" do
          expect(page).to have_content("Your client or their partner’s name must be on the property deeds, lease, freehold or mortgage.")
        end
      end
    end

    context "when going to check_answers" do
      before do
        fill_in_forms_until(:check_answers)
      end

      context "without MTR accelerated" do
        let(:content_date) { before_date }

        it "shows old content" do
          expect(page).to have_content("Does your client own the home the client lives in?")
          expect(page).to have_content("Home client lives in details")
        end
      end

      context "with MTR accelerated", :mtr_accelerated_flag do
        let(:content_date) { after_date }

        it "shows new content" do
          expect(page).to have_content("Does your client own the home the client usually lives in?")
          expect(page).to have_content("Home client owns and usually lives in details")
        end
      end
    end
  end
end
