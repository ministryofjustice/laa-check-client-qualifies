require "rails_helper"

RSpec.describe "provider_users page to check user type", type: :request do
  describe "GET /provider_users" do
    subject(:request) { get provider_users_path }

    before do
      request
    end

    it "returns http success" do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /provider_users" do
    subject(:request) { post provider_users_path(params) }

    context "when the user is a legal aid provider" do
      let(:params) { { "provider_user" => { "provider_user_valid" => "true" } } }

      it "redirects to the build estimates page" do
        request
        expect(response).to redirect_to(new_estimate_path)
      end
    end

    context "when the user is not a valid user" do
      let(:params) { { "provider_user" => { "provider_user_valid" => "false" } } }

      it "redirects to the referrals page" do
        request
        expect(response).to redirect_to(referrals_path)
      end
    end

    context "when the user does not enter a response" do
      let(:params) { { "provider_user" => { "provider_user_valid" => "" } } }

      it "shows the user an error" do
        request
        expect(response.body).to include I18n.t("activemodel.errors.models.provider_user.attributes.blank")
      end
    end
  end
end
