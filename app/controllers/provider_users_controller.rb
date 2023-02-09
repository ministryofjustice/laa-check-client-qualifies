class ProviderUsersController < ApplicationController
  before_action :track_page_view, only: :show

  def show
    provider_user
  end

  def create
    case params[:provider_user][:provider_user_valid]
    when "true"
      redirect_to new_estimate_path
    when "false"
      redirect_to referrals_path
    else
      track_validation_error
      provider_user.errors.add(:provider_user_valid, I18n.t("activemodel.errors.models.provider_user.attributes.blank"))
      render :show
    end
  end

private

  def provider_user
    @provider_user ||= ProviderUser.new
  end
end
