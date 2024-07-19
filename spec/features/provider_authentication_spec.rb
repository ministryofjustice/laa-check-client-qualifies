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
      create(:provider, email: mock_auth.info.fetch("email"), first_office_code: Faker::String.random)
    end

    scenario "callback" do
      expect {
        visit provider_saml_omniauth_callback_path
      }.not_to change(Provider, :count)
      expect(Provider.last.reload.first_office_code).to eq(mock_auth.info.fetch("office_codes").first)
    end
  end
end
