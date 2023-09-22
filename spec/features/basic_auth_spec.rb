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
      expect(page).to have_content "This URL is private"
    end

    scenario "I can access the screen if I provide a password" do
      visit root_path
      fill_in :password, with: "password"
      click_on "Continue"
      expect(page).to have_content "This service will ask you questions about your client, then tell you if they are likely to get civil legal aid, based on their financial situation."
    end

    scenario "I am returned to the path I was on" do
      visit help_path
      fill_in :password, with: "password"
      click_on "Continue"
      expect(page).to have_current_path help_path
    end

    scenario "The wrong password generates an error" do
      visit root_path
      fill_in :password, with: "wrong"
      click_on "Continue"
      expect(page).to have_content "There is a problem"
    end

    scenario "I am not looped" do
      visit new_basic_authentication_session_path
      fill_in :password, with: "password"
      click_on "Continue"
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end
end
