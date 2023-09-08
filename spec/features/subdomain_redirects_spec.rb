require "rails_helper"

RSpec.describe "SubdomianRedirectsController method", type: :feature do
  context "when I'm from a correct url" do
    it "redirects to admin_google_oauth2_omniauth_callback_path" do
      state = "https://UATbranch.cloud-patform.service.justice.gov.uk"

      # Google re-directs us to SubdomainRedirectsController and calls method
      visit "#{subdomain_redirects_path}?state=#{state}"

      # Expect the redirect to happen and us to be logged in
      expect(page).to have_current_path("/admins/sign_in")
    end
  end

  context "when I'm from an incorrect url" do
    it "raises an error" do
      state = "https://CrossSiteRequestForgery.com"

      # Google re-directs us to SubdomainRedirectsController and calls method, and this instantly raises an error
      expect { visit "#{subdomain_redirects_path}?state=#{state}" }.to raise_error("Invalid state provided by omniauth callback!")
    end
  end
end
