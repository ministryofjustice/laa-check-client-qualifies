class RobotsController < ApplicationController
  skip_before_action :authenticate, only: :index

  def index
    if FeatureFlags.enabled?(:index_production, without_session_data: true)
      render "robots_allow"
    else
      render "robots_disallow"
    end
  end
end
