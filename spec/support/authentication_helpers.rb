def authenticate_as_admin
  Admin.create! email: "foo@example.com"
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    "info" => { "email" => "foo@example.com" },
  })
  visit admin_google_oauth2_omniauth_callback_path
end
