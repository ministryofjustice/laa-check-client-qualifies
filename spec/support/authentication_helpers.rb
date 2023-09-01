def authenticate_as_admin
  Admin.create! email: "foo@example.com"
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    "info" => { "email" => "foo@example.com" },
  })
  visit "/admin"
  click_on "Sign in with Google"
end
