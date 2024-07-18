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
end
