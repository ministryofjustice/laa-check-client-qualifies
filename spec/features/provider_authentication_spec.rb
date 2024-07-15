require "rails_helper"

RSpec.describe "Provider authentication" do
  before do
    OmniAuth.config.mock_auth[:saml] = LaaPortal::SamlStrategy.mock_auth
  end

  context "without an existing record" do
    scenario "callback" do
      expect {
        visit provider_saml_omniauth_callback_path
      }.to change(Provider, :count).by(1)
    end
  end

  context "with an existing record" do
    before do
      create(:provider, email: "provider@example.com")
    end

    scenario "callback" do
      expect {
        visit provider_saml_omniauth_callback_path
      }.not_to change(Provider, :count)
    end
  end
end
