require "rails_helper"

RSpec.describe "Admin authentication" do
  context "when I am a valid admin" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        "info" => { "email" => "foo@example.com" },
      })

      Admin.create! email: "foo@example.com"
    end

    scenario "I visit the admin panel" do
      visit admin_google_oauth2_omniauth_callback_path
      expect(page).to have_current_path("/admin")
    end
  end

  context "when I am not a valid admin" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        "info" => { "email" => "imposter@example.com" },
      })

      Admin.create! email: "foo@example.com"
    end

    scenario "I visit the admin panel" do
      visit admin_google_oauth2_omniauth_callback_path
      expect(page).to have_current_path("/admins/sign_in")
      expect(page).to have_content "You are not recognised as an admin"
    end
  end
end
