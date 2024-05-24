module Admins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: %i[google_oauth2]

    def google_oauth2
      admin = Admin.find_by(email: auth_hash.info.email)

      if admin
        sign_in_and_redirect admin, event: :authentication
      else
        redirect_to new_admin_session_path, flash: { notice: I18n.t("devise.unrecognised") }
      end
    end

  private

    # def after_omniauth_failure_path_for(_)
    #   new_provider_session_path
    # end

    def auth_hash
      request.env["omniauth.auth"]
    end
  end
end
