# frozen_string_literal: true

module Providers
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: %i[saml]

    def saml
      info_hash = request.env["omniauth.auth"].info
      info_hash_email = info_hash["email"]
      info_hash_office_code = info_hash["office_codes"].first

      provider = Provider.find_by(email: info_hash_email)
      if provider.present?
        provider.update! first_office_code: info_hash_office_code
      else
        provider = Provider.create! email: info_hash_email, first_office_code: info_hash_office_code
      end

      # reset the session on login, otherwise the session expires after 14 days
      # and logouts crash because there is no session data (SAML_UID) to logout with
      # This may need to change if we want to preserve check data over a login
      # https://stackoverflow.com/questions/4812813/rails-login-reset-session
      #
      # Some docs suggest that devise maybe doing this behind the scenes, so
      # this might be an investigation if changing this doesn't work.
      reset_session
      # Portal has checked that we have the correct role, so we can just sign in
      sign_in_and_redirect provider, event: :authentication
    end

  private

    def after_sign_in_path_for(_provider)
      root_path
    end
  end
end
