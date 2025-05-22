require "rails_helper"

RSpec.describe "property_landlord", :calls_cfe_early_returns_not_ineligible, type: :feature do
  let(:title) { I18n.t("question_flow.property_landlord.legend") }
  let(:property_owned) { "Yes, through a shared ownership scheme" }
  let(:partner) { false }

  context "when client is means-tested" do
    before do
      start_assessment
      fill_in_forms_until(:applicant)
      if partner
        fill_in_applicant_screen(partner: "Yes")
      else
        fill_in_applicant_screen(partner: "No")
      end
      fill_in_forms_until(:property)
      fill_in_property_screen(choice: property_owned)
    end

    it "shows an error message if no value is entered" do
      click_on "Save and continue"
      expect(page).to have_content title
      expect(page).to have_content "Select yes if the landlord is the only other joint-owner"
    end

    it "stores the chosen value in the session" do
      choose "Yes"
      click_on "Save and continue"
      expect(session_contents["property_landlord"]).to be true
    end

    it "stores the chosen value in the session and subsequent page in `cannot-use-service`" do
      choose "No"
      click_on "Save and continue"
      expect(session_contents["property_landlord"]).to be false
    end
  end

  context "when client is non-means-tested" do
    before do
      start_assessment
      fill_in_client_age_screen(choice: "Under 18")
      fill_in_level_of_help_screen(choice: "Civil controlled work or family mediation")
      fill_in_under_18_controlled_legal_rep_screen(choice: "No")
      fill_in_aggregated_means_screen(choice: "No")
      fill_in_regular_income_screen(choice: "Yes")
      fill_in_forms_until(:property)
      fill_in_property_screen(choice: property_owned)
    end

    it "shows an error message if no value is entered" do
      click_on "Save and continue"
      expect(page).to have_content title
      expect(page).to have_content "Select yes if the landlord is the only other joint-owner"
    end

    it "stores the chosen value in the session" do
      choose "Yes"
      click_on "Save and continue"
      expect(session_contents["property_landlord"]).to be true
    end
  end

  context "when client is passported" do
    let(:passporting) { "Yes" }

    before do
      start_assessment
      fill_in_client_age_screen
      fill_in_level_of_help_screen
      fill_in_domestic_abuse_applicant_screen
      fill_in_immigration_or_asylum_type_upper_tribunal_screen
      fill_in_applicant_screen(passporting:)
      fill_in_forms_until(:property)
      fill_in_property_screen(choice: property_owned)
    end

    it "shows an error message if no value is entered" do
      click_on "Save and continue"
      expect(page).to have_content title
      expect(page).to have_content "Select yes if the landlord is the only other joint-owner"
    end

    it "stores the chosen value in the session" do
      choose "Yes"
      click_on "Save and continue"
      expect(session_contents["property_landlord"]).to be true
    end
  end
end
