require "rails_helper"

RSpec.describe "referrals page for non valid users", type: :request do
  describe "GET /referrals" do
    subject(:request) { get referrals_path }

    before do
      request
    end

    it "returns http success" do
      expect(response).to have_http_status(:ok)
    end
  end
end
