class SubdomainRedirectsController < ApplicationController
  before_action :subdomain_redirects, only:

  def subdomain_redirects
    state = params[:state]

    if state.ends_with?(".gov.uk") || state.include?("127.0.0.1:3000") || state.include?("localhost:3000")
      redirect_to "#{params[:state][0...-1]}#{admin_google_oauth2_omniauth_callback_path(code: params[:code], scope: params[:scope], authuser: params[:authuser], hd: params[:hd], prompt: params[:prompt])}", allow_other_host: true
      # params come back from Google and are Google would like us to include them in the redirect url
      # redirect url for local host would look like   - http://127.0.0.1:3000/admins/code=123xyz?scope=googleapi?authuser=0?hd=digital.justice.gov.uk?prompt=none
      # redirect url for local host would look like   - http://localhost:3000/admins/code=123xyz?scope=googleapi?authuser=0?hd=digital.justice.gov.uk?prompt=none
      # redirect url for a UAT branch would look like - https://el-xxxx-foo-bar-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk/code=123xyz?scope=googleapi?authuser=0?hd=digital.justice.gov.uk?prompt=none
    else
      raise "Invalid state provided by omniauth callback!"
    end
  end
end
