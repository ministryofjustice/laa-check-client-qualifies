require "rails_helper"

RSpec.describe "Basic auth" do
  around do |example|
    ENV["BASIC_AUTH_PASSWORD"] = "password"
    example.run
    ENV["BASIC_AUTH_PASSWORD"] = nil
  end

  context "when basic authentication is enabled", :basic_authentication_flag do
    scenario "I can't access any screen without a password" do
      visit root_path
      expect(page).to have_content "HTTP Basic: Access denied."
    end

    scenario "I can access the screen if I provide a password" do
      page.driver.browser.basic_authorize("ccq", "password")
      visit root_path
      expect(page).to have_content "Check if your client qualifies for legal aid"
    end
  end
end
