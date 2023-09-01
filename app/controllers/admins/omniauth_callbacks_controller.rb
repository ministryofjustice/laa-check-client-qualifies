module Admins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def google_oauth2
      current_url = request.url
      puts "11111111111111"
      puts "11111111111111"
      puts "11111111111111"
      puts "11111111111111"
      puts "11111111111111"
      puts current_url
      binding.pry

      admin = Admin.find_by(email: request.env["omniauth.auth"].info.email)

      if admin
        sign_in_and_redirect admin, event: :authentication, state: current_url
      else
        redirect_to new_admin_session_path, flash: { notice: I18n.t("devise.unrecognised") }
      end
    end
  end
end
