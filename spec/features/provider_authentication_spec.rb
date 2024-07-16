require "rails_helper"

RSpec.describe "Provider authentication" do
  let(:mock_auth) { build(:mock_saml_auth) }

  before do
    OmniAuth.config.mock_auth[:saml] = mock_auth
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
      create(:provider, email: mock_auth.info["email"], first_office_code: mock_auth.info["LAA"])
    end

    scenario "callback" do
      expect {
        visit provider_saml_omniauth_callback_path
      }.not_to change(Provider, :count)
    end
  end
end
