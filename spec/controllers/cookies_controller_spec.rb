require "rails_helper"

RSpec.describe CookiesController, type: :controller do
  before do
    cookies.delete(:optional_cookie_choice)
  end

  describe "PATCH" do
    it "sets an 'accepted' value'" do
      patch :update, params: { cookies: "accept" }
      expect(cookies[:optional_cookie_choice]).to eq "accepted"
    end

    it "sets an 'rejected' value'" do
      patch :update, params: { cookies: "reject" }
      expect(cookies[:optional_cookie_choice]).to eq "rejected"
    end

    it "redirects to root with a param by default" do
      response = patch :update, params: { cookies: "reject" }
      expect(response).to redirect_to root_path(cookie_choice: "rejected")
    end

    it "redirects to given path with a param if one provided" do
      response = patch :update, params: { cookies: "reject", return_to: new_estimate_path }
      expect(response).to redirect_to new_estimate_path(cookie_choice: "rejected")
    end

    it "omits query params in redirect when returning to the cookies path if one provided" do
      response = patch :update, params: { cookies: "reject", return_to: cookies_path }
      expect(response).to redirect_to cookies_path
    end
  end
end
