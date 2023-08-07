require "rails_helper"

RSpec.describe ServiceUnavailableController, type: :controller do
  describe "#index" do
    context "when the feature flag is turned on", :maintenance_mode do
      it "redirects to the correct page" do
        get :index
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end
end
