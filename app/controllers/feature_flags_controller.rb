class FeatureFlagsController < ApplicationController
  #TODO: HTTP Basic auth for edit and update paths
  def index; end

  def edit
    redirect_to root_path unless FeatureFlags.overrideable?
    @model = FeatureFlagOverride.find_by(key: params[:id]) || FeatureFlagOverride.new(key: params[:id])
  end

  def update
    redirect_to root_path unless FeatureFlags.overrideable?
    model = FeatureFlagOverride.find_or_create_by!(key: params[:id])
    model.update!(params.require(:feature_flag_override).permit(:value))
    redirect_to feature_flags_path
  end
end
