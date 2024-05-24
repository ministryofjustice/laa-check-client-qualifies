# frozen_string_literal: true

# from https://kodius.com/blog/devise-omniauth-multiple-models
# Devise itself is also quite helpful
# https://github.com/heartcombo/devise/wiki/OmniAuth-with-multiple-models
# https://github.com/omniauth/omniauth-saml
#
Rails.application.config.middleware.use OmniAuth::Builder do
  # This sends all auth failures/cancels to Devise::OmniauthCallbacksController#failure
  on_failure { |env| Admins::OmniauthCallbacksController.action(:failure).call(env) }

  provider :google_oauth2,
           ENV["GOOGLE_OAUTH_CLIENT_ID"],
           ENV["GOOGLE_OAUTH_CLIENT_SECRET"],
           scope: "email",
           redirect_uri: ENV["GOOGLE_OAUTH_REDIRECT_URI"]

  cert_file = Rails.root.join("config/saml/certificates", ENV.fetch("LAA_PORTAL_X509_CERT", "cert-uat.pem"))
  cert_data = File.read(cert_file)

  # This hard-coded private key fallback isn't really needed (as tests don't use it)
  # if we need it, it should be in LAA_PORTAL_X509_KEY (spike only)
  private_key_fallback = Rails.root.join("config/saml/certificates/uat-private-key.pem")
  private_key_data = ENV.fetch("LAA_PORTAL_X509_KEY", File.exist?(private_key_fallback) && File.read(private_key_fallback))

  #  Our (SP) metadata can be downloaded from http://localhost:3000/providers/auth/saml/metadata
  # and given to the portal team so it matches what is in our code.

  # name: is required here as otherwise the URLs are based off of the lower class name
  # which ends up as /auth/samlstrategy which doesn't work properly
  provider LaaPortal::SamlStrategy,
           name: "saml",
           path_prefix: "/providers/auth",
           # This is a 'setup' step which might not actually be needed - it's only purpose
           # appears to be obtaining the request_url (which can be tricky without a request)
           # for the logout journey
           setup: LaaPortal::SamlSetup,
           sp_entity_id: "check-client-qualifies",
           certificate: cert_data,
           private_key: private_key_data,
           name_identifier_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified",
           # mappings of SAML attributes to auth info hash
           attribute_statements: {
             email: %w[USER_EMAIL],
             roles: %w[LAA_APP_ROLES],
             office_codes: %w[LAA_ACCOUNTS],
           },
           # disable request attributes of first, last, family name etc
           request_attributes: {},
           security: {
             digest_method: XMLSecurity::Document::SHA256,
             signature_method: XMLSecurity::Document::RSA_SHA256,
             authn_requests_signed: true,
             logout_responses_signed: true,
             want_assertions_signed: true,
             want_assertions_encrypted: true,
             check_idp_cert_expiration: true,
             check_sp_cert_expiration: true,
           }
end

# Otherwise OmniAuth logs to stdout/stderr
OmniAuth.config.logger = Rails.logger
