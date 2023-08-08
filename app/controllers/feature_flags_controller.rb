class FeatureFlagsController < ApplicationController
  before_action :check_flags_overrideable, only: %i[edit update]

  def index; end

  def edit
    @model = FeatureFlagOverride.find_by(key: params[:id]) || FeatureFlagOverride.new(key: params[:id])
  end

  def update
    model = FeatureFlagOverride.find_or_create_by!(key: params[:id])
    model.update!(params.require(:feature_flag_override).permit(:value))
    redirect_to feature_flags_path
  end

private

  def check_flags_overrideable
    redirect_to root_path unless FeatureFlags.overrideable?
  end
end
