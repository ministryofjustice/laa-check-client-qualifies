require "rails_helper"

# In this case we use a controller spec because it allows for easily detecting redirects to external sites.
RSpec.describe OauthRedirectsController, type: :controller do
  describe "google_redirect" do
    it "sets session state nonce" do
      post :google_redirect
      expect(session["omniauth.state"]).to be_present
    end

    it "redirects to Google" do
      post :google_redirect
      expect(response.headers["Location"]).to start_with "https://accounts.google.com/o/oauth2/v2/auth"
    end
  end

  describe "subdomain_redirect" do
    it "highlights an error if an invalid state param is provided" do
      get :subdomain_redirect, params: { state: "https://somemalicioussite.com?falsity=cloud-platform.service.justice.gov.uk" }
      expect(response).to redirect_to "/admins/sign_in"
      expect(flash[:notice]).to eq "Invalid subdomain provided in state param"
    end

    it "highlights an error if no state param is provided" do
      get :subdomain_redirect
      expect(response).to redirect_to "/admins/sign_in"
      expect(flash[:notice]).to eq "Invalid subdomain provided in state param"
    end

    it "redirects to an appropriate subdomain" do
      get :subdomain_redirect, params: { state: "https://valid-subdomain.cloud-platform.service.justice.gov.uk?state=foo", code: "bar" }
      expect(response).to redirect_to "https://valid-subdomain.cloud-platform.service.justice.gov.uk/admins/auth/google_oauth2/callback?state=foo&code=bar"
    end
  end
end
