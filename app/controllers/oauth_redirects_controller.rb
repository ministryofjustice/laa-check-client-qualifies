class OauthRedirectsController < ApplicationController
  # We use a custom URL to initiate the redirect to Google so that we can generate
  # a state param that both contains the standard anti-CSRF nonce _and_ contains the information
  # we need to perform subdomain redirects (see below)
  def google_redirect
    nonce = SecureRandom.hex(24)
    session["omniauth.state"] = nonce # Omniauth will look in this locatin in the session when doing its own CSRF checking later.
    uri = URI.parse("https://accounts.google.com/o/oauth2/v2/auth")
    uri.query = { client_id: ENV["GOOGLE_OAUTH_CLIENT_ID"],
                  redirect_uri: ENV["GOOGLE_OAUTH_REDIRECT_URI"],
                  scope: "email",
                  response_type: "code",
                  include_granted_scopes: true,
                  state: root_url(state: nonce) }.to_query
    redirect_to uri.to_s, allow_other_host: true
  end

  # We have lots of different subdomains that may want to authenticate with Google, but
  # we don't want to have to tell Google about each one. So for each environment we only
  # tell Google about one subdomain, and tell it to redirect to this action on that subdomain,
  # passing the URL of the subdomain we actually want to authenticate in the `state` param.
  # Here we check that the requested subdomain is valid, and if so, redirect back to it.
  # Note that the requested subdomain in the state param will itself contain a state param
  # with an anti-CSRF nonce, so we need to make sure that is preserved when redirecting onwards
  def subdomain_redirect
    uri = URI.parse(params[:state])
    if uri.hostname.ends_with?("cloud-platform.service.justice.gov.uk") || request.host == uri.hostname
      uri.path = admin_google_oauth2_omniauth_callback_path
      uri.query += "&#{params.slice(:code, :scope, :authuser, :hd, :prompt).permit!.to_query}"
      redirect_to uri.to_s, allow_other_host: true
    else
      raise "Invalid subdomain provided in state param"
    end
  end
end
