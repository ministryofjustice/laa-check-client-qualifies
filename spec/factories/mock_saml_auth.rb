FactoryBot.define do
  factory :mock_saml_auth, class: OmniAuth::AuthHash do
    provider { "saml" }
    uid { "test-user" }
    info do
      {
        email: "provider@example.com",
        roles: %w[CCQ],
        office_codes: %w[1A123B 2A555X 3B345C 4C567D],
      }
    end
  end
end
