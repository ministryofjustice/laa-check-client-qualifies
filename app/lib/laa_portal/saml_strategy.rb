# frozen_string_literal: true

module LaaPortal
  class SamlStrategy < OmniAuth::Strategies::SAML
    # :nocov:
    def auth_hash
      hash = super

      Rails.logger.debug("auth_hash before #{hash.info}")

      hash.merge(
        info: {
          email: hash.info.email,
          roles: hash.info.roles.split(","),
          office_codes: hash.info.office_codes.to_s.split(":"),
        },
      ).tap do |auth|
        Rails.logger.debug("auth_hash after #{auth.info}")
      end
    end
    # :nocov:

    class << self
      def mock_auth
        OmniAuth::AuthHash.new(
          provider: "saml",
          uid: "test-user",
          info: {
            email: "provider@example.com",
            roles: %w[CCQ],
            office_codes: %w[1A123B 2A555X 3B345C 4C567D],
          },
        )
      end
    end
  end
end
