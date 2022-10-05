class CookiesController < ApplicationController
  def update
    choice = params[:cookies] == "accept" ? "accepted" : "rejected"
    cookies[:optional_cookie_choice] = { value: choice, expires: 1.year }

    redirect_to build_return_to_url(choice)
  end

  def show; end

private

  def build_return_to_url(choice)
    return root_path(cookie_choice: choice) if params[:return_to].blank?
    return cookies_path if params[:return_to] == cookies_path

    uri = URI.parse(params[:return_to])
    original_query_parts = uri.query.present? ? URI.decode_www_form(uri.query) : []
    new_query_parts = [["cookie_choice", choice]]
    uri.query = URI.encode_www_form(original_query_parts + new_query_parts)
    uri.to_s
  end
end
