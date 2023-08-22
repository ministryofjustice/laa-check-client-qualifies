class BasicAuthenticationSessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]

  def new; end

  def create
    if params[:password].strip == ENV["BASIC_AUTH_PASSWORD"]
      cookies.signed[BASIC_AUTHENTICATION_COOKIE] = { value: true, expires: 1.year, httponly: true, secure: Rails.env.production? }
      if session["user_return_to"].blank? || session["user_return_to"] == new_basic_authentication_session_path
        redirect_to root_path
      else
        redirect_to session["user_return_to"]
      end
    else
      @error = true
      render :new
    end
  end
end
