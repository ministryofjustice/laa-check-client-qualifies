require "rails_helper"

RSpec.describe "Provider login", type: :feature do
  before do
    OmniAuth.config.mock_auth[:saml] = build(:mock_saml_auth)
  end

  context "when signed in" do
    let(:email_address) { Faker::Internet.email }

    before do
      sign_in create(:provider, email: email_address, first_office_code: "1Q630KL")
      visit "/"
    end

    it "displays the user in the banner" do
      expect(page).to have_content(email_address)
    end

    it "goes to the signed out start page on sign out" do
      click_on "Sign Out"
      expect(page).to have_content("You are now signed out of the application")
    end
  end

  context "when signed in I can complete a check" do
    let(:email_address) { Faker::Internet.email }

    before do
      sign_in create(:provider, email: email_address, first_office_code: "1Q630KL")
      visit "/"
      stub_request(:post, %r{v6/assessments\z}).to_return(
        body: build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )
      start_assessment
      fill_in_forms_until(:check_answers)
      click_on "Submit"
    end

    it "displays the result panel content" do
      expect(page).to have_content("Your client is likely to qualify for civil legal aid")
    end
  end

  context "when signed in I can complete an early eligibility check" do
    let(:email_address) { Faker::Internet.email }

    before do
      sign_in create(:provider, email: email_address, first_office_code: "1Q630KL")
      visit "/"
      stub_request(:post, %r{v6/assessments\z}).to_return(
        body: build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )
      first = instance_double(CfeResult, ineligible_gross_income?: true,
                                         gross_income_excess: 100,
                                         gross_income_result: "ineligible")
      second = instance_double(CfeResult, ineligible_gross_income?: false,
                                          gross_income_excess: 0,
                                          gross_income_result: "eligible")
      allow(CfeService).to receive(:result).and_return(first, second)
      allow(CfeService).to receive(:call).and_return build(:api_result, eligible: "ineligible")
      start_assessment
      fill_in_forms_until(:applicant)
      fill_in_applicant_screen(partner: "No", passporting: "No")
      fill_in_dependant_details_screen
      fill_in_employment_status_screen(choice: "Employed or self-employed")
      fill_in_income_screen(gross: "8000", frequency: "Every month")
      fill_in_forms_until(:other_income)
      fill_in_other_income_screen_with_friends_and_family
    end

    it "when I continue the check" do
      confirm_screen("outgoings")
      expect(page).to have_content("Gross monthly income limit exceeded")
      fill_in_outgoings_screen
      expect(page).not_to have_content("Gross monthly income limit exceeded")
      fill_in_forms_until(:check_answers)
      click_on "Submit"
      expect(page).to have_current_path(/\A\/check-result/)
      expect(page).to have_content "Your client's key eligibility totals"
    end

    it "when I go straight to results the check" do
      confirm_screen("outgoings")
      expect(page).to have_content("Gross monthly income limit exceeded")
      click_on "Go to results page"
      expect(page).to have_current_path(/\A\/check-result/)
      expect(page).to have_content "Your client's key eligibility totals"
    end
  end
end
