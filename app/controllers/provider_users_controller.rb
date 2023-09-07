class ProviderUsersController < ApplicationController
  before_action :track_page_view, only: :show

  def show
    provider_user
  end

  def create
    case params[:provider_user][:legal_aid_provider]
    when "true"
      redirect_to new_check_path
    when "false"
      redirect_to referrals_path
    else
      track_validation_error
      provider_user.errors.add(:legal_aid_provider, I18n.t("activemodel.errors.models.provider_user.attributes.blank"))
      render :show
    end
  end

private

  def provider_user
    @provider_user ||= ProviderUser.new
  end
end
