# frozen_string_literal: true

module LaaPortal
  class SamlStrategy < OmniAuth::Strategies::SAML
    # def on_path?(path)
    #   Rails.logger.debug "on_path? #{path}"
    #   super
    # end

    # :nocov:
    def auth_hash
      # self.class.auth_adapter.call(super)
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
        # auth_adapter.call(
        OmniAuth::AuthHash.new(
          provider: "saml",
          uid: "test-user",
          info: {
            email: "provider@example.com",
            roles: %w[CCQ],
            office_codes: %w[1A123B 2A555X 3B345C 4C567D],
          },
        )
        # )
      end

      # class AuthAdapter
      #   class << self
      #     def call(auth_hash)
      #       auth_hash.merge(
      #         info: {
      #           email: auth_hash.info.email,
      #           roles: auth_hash.info.roles.to_s.split(","),
      #           office_codes: auth_hash.info.office_codes.to_s.split(":"),
      #         },
      #       )
      #     end
      #   end
      # end
      #
      # def auth_adapter
      #   AuthAdapter
      # end
    end
  end
end
