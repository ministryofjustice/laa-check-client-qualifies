module Providers
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: %i[saml]

    def saml
      info_hash = request.env["omniauth.auth"].info

      provider = Provider.find_or_create_by! email: info_hash["email"]
      # office_codes: info_hash['office_codes'],
      # roles: info_hash['roles']

      # we don't need to check here that the user has role 'CCQ' but we might need to
      # double-check whether this a correct assumption (and that portal doesn't enforce this)
      sign_in_and_redirect provider, event: :authentication
    end

  private

    def after_sign_in_path_for(_provider)
      provider_secrets_path
    end

    # def after_omniauth_failure_path_for(_)
    #   new_provider_session_path
    # end

    # def new_session_path(_scope)
    #   new_provider_session_path
    # end
  end
end
