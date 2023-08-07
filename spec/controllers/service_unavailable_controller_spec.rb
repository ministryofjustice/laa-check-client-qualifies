require "rails_helper"

RSpec.describe ServiceUnavailableController, type: :controller do
  describe "GET #index" do
    it "has the http status of 503" do
      get :index
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
