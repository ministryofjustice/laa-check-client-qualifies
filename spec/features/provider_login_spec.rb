require "rails_helper"

RSpec.describe "Provider login", type: :feature do
  before do
    OmniAuth.config.mock_auth[:saml] = LaaPortal::SamlStrategy.mock_auth
  end

  context "when signed in" do
    let(:email_address) { Faker::Internet.email }

    before do
      sign_in create(:provider, email: email_address)
      visit "/"
    end

    it 'displays the user in the banner' do
      expect(page).to have_content(email_address)
    end

    it "goes to the signed out start page on sign out" do
      click_on 'Sign Out'
      expect(page).to have_content("You are now signed out of the application")
    end
  end
end
