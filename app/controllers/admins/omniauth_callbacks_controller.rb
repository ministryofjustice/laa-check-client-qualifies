module Admins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def google_oauth2
      admin = Admin.find_by(email: request.env["omniauth.auth"].info.email)

      if admin
        sign_in_and_redirect admin, event: :authentication
      else
        redirect_to new_admin_session_path
      end
    end

    def failure
      redirect_to new_admin_session_path
    end
  end
end
