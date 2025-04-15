require "rails_helper"

RSpec.describe "Cannot use service flow", :ee_banner, :shared_ownership, :stub_cfe_calls_with_webmock, type: :feature do
  context "when the client's main home is shared ownership and the landlord is not the only other joint owner" do
    it "shows me a screen to indicate that I cannot use the service" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "Yes")
      fill_in_forms_until(:property)
      fill_in_property_screen(choice: "Yes, through a shared ownership scheme")
      fill_in_property_landlord_screen(choice: "No")
      confirm_screen(:cannot_use_service)
      expect(page).to have_content "You cannot use this service"
      expect(page).to have_content "You cannot use this service if your client joint-owns a shared ownership property with the landlord and someone else."
    end
  end

  context "when the client has a main property and changes the ownership to shared ownership" do
    it "shows me a screen to indicate that I cannot use the service" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "Yes")
      fill_in_forms_until(:property)
      fill_in_property_screen(choice: "No")
      fill_in_forms_until(:check_answers)
      confirm_screen("check_answers")
      within "#table-property" do
        click_on "Change"
      end
      confirm_screen(:property)
      fill_in_property_screen(choice: "Yes, through a shared ownership scheme")
      fill_in_property_landlord_screen(choice: "No")
      expect(page).to have_content "You cannot use this service"
      expect(page).to have_content "You cannot use this service if your client joint-owns a shared ownership property with the landlord and someone else."
      click_on "Back"
      confirm_screen(:property_landlord)
      click_on "Back"
      confirm_screen(:property)
    end
  end

  context "when the client has an additional shared ownership property" do
    it "shows me a screen to indicate that I cannot use the service" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "Yes")
      fill_in_forms_until(:additional_property)
      fill_in_additional_property_screen(choice: "Yes, through a shared ownership scheme")
      confirm_screen(:cannot_use_service)
      expect(page).to have_content "You cannot use this service"
      expect(page).to have_content "You cannot use this service if your client owns a shared ownership property that they do not live in."
    end
  end

  context "when the client's partner has an additional shared ownership property" do
    it "shows me a screen to indicate that I cannot use the service" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "Yes", passporting: "Yes")
      fill_in_forms_until(:partner_additional_property)
      fill_in_partner_additional_property_screen(choice: "Yes, through a shared ownership scheme")
      confirm_screen(:cannot_use_service)
      expect(page).to have_content "You cannot use this service"
      expect(page).to have_content "You cannot use this service if your client or their partner owns a shared ownership property that they do not live in."
    end
  end

  context "when the client has an additional property and changes the ownership to shared ownership" do
    it "shows me a screen to indicate that I cannot use the service" do
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "Yes")
      fill_in_forms_until(:additional_property)
      fill_in_additional_property_screen(choice: "No")
      fill_in_forms_until(:check_answers)
      within "#table-additional_property" do
        click_on "Change"
      end
      confirm_screen(:additional_property)
      fill_in_additional_property_screen(choice: "Yes, through a shared ownership scheme")
      expect(page).to have_content "You cannot use this service"
      expect(page).to have_content "You cannot use this service if your client owns a shared ownership property that they do not live in."
      click_on "Back"
      confirm_screen(:additional_property)
    end
  end
end
