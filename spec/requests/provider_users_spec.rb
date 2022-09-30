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

    let(:params) { [:provider_user][:provider_user_valid] = "true" }

    before do
      request
    end

    it "returns http success" do
      expect(response).to have_http_status(:ok)
    end
  end
end
