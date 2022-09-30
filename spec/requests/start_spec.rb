require "rails_helper"

RSpec.describe "start of user journey", type: :request do
  describe "GET /start" do
    subject(:request) { get root_path }

    before do
      request
    end

    it "returns http success" do
      expect(response).to have_http_status(:ok)
    end
  end
end
