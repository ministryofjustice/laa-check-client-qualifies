# frozen_string_literal: true

module Providers
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: %i[saml]

    def saml
      info_hash = request.env["omniauth.auth"].info

      provider = Provider.find_or_create_by! email: info_hash["email"], first_office_code: info_hash["office_codes"].first

      # Portal has checked that we have the correct role, so we can just sign in
      sign_in_and_redirect provider, event: :authentication
    end

  private

    def after_sign_in_path_for(_provider)
      root_path
    end
  end
end
