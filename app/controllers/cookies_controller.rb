class CookiesController < ApplicationController
  COOKIE_CHOICE_NAME = :optional_cookie_choice
  def update
    choice = params[:cookies] == "accept" ? "accepted" : "rejected"
    cookies[COOKIE_CHOICE_NAME] = { value: choice, expires: 1.year, httponly: true, secure: Rails.env.production? }

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
end
