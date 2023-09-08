module Admins
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def subdomain_redirects
      if params[:state].ends_with?(".gov.uk") || params[:state].include?("localhost:3000")
        # redirect url for local host UAT would look like - https://127.0.0.1:3000/admins/google_oauth2/callback?host=main-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk&access_token=abc123
        # redirect url for local host UAT would look like - https://localhost:3000/admins/google_oauth2/callback?host=main-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk&access_token=abc123
        # redirect url for a UAT branch wouls look like - https://el-xxxx-foo-bar-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk/admins/google_oauth2/callback?host=main-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk&access_token=abc123
        redirect_to admin_google_oauth2_omniauth_callback_url(host: params[:state], access_token: params[:access_token])
      else
        raise "Invalid state provided by omniauth callback!"
      end
    end

    def google_oauth2
      admin = Admin.find_by(email: request.env["omniauth.auth"].info.email)

      if admin
        sign_in_and_redirect admin, event: :authentication
      else
        redirect_to new_admin_session_path, flash: { notice: I18n.t("devise.unrecognised") }
      end
    end
  end
end
