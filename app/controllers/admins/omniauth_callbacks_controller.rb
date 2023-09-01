module Admins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def google_oauth2
      admin = Admin.find_by(email: request.env["omniauth.auth"].info.email)

      if admin
        redirect_url = request.params("state").split("s/sign_in")[0]

        sign_in_and_redirect admin, event: :authentication, redirect_url:
      else
        redirect_to new_admin_session_path, flash: { notice: I18n.t("devise.unrecognised") }
      end
    end
  end
end
