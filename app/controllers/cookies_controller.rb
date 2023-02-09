class CookiesController < ApplicationController
  before_action :track_page_view, only: :show

  COOKIE_CHOICE_NAME = :optional_cookie_choice
  def update
    choice = params[:cookies] == "accept" ? "accepted" : "rejected"
    cookies[COOKIE_CHOICE_NAME] = { value: choice, expires: 1.year, httponly: true, secure: Rails.env.production? }
    set_browser_id_cookie(params[:cookies] == "accept")

    redirect_to build_return_to_url(choice)
  end

  def show; end

private

  def build_return_to_url(choice)
    uri = URI.parse(params[:return_to].presence || cookies_path)
    original_query_parts = uri.query.present? ? URI.decode_www_form(uri.query) : []
    new_query_parts = params[:add_choice_to_query_string] ? [["cookie_choice", choice]] : []
    combined = original_query_parts + new_query_parts
    uri.query = URI.encode_www_form(combined) if combined.present?
    uri.to_s
  end

  def set_browser_id_cookie(accept_cookies)
    # noop if we have a browser id cookie and want to accept such cookies,
    # or we don't and we don't
    return if cookies[BROWSER_ID_COOKIE].present? == accept_cookies

    if accept_cookies
      cookies[BROWSER_ID_COOKIE] = { value: SecureRandom.uuid, expires: 1.year, httponly: true, secure: Rails.env.production? }
    else
      cookies.delete(BROWSER_ID_COOKIE)
    end
  end
end
