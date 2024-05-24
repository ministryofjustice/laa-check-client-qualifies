require "rails_helper"

RSpec.describe "Provider login" do
  before do
    OmniAuth.config.mock_auth[:saml] = LaaPortal::SamlStrategy.mock_auth
  end

  context "when accessing private resources" do
    before do
      visit provider_secrets_path
      click_on "Sign in with Portal"
    end

    it "shows top secret" do
      expect(page).to have_content "This is top secret"
    end

    it "shows a sign out link" do
      expect(page).to have_content "Sign Out"
    end

    it "shows the provider email" do
      expect(page).to have_content "provider@example.com"
    end
  end
end
