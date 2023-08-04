require "rails_helper"

RSpec.describe MaintenanceController, type: :controller do
  describe "GET index" do
    it "renders the maintenance page " do
      get :index
      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
