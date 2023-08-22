class StartController < ApplicationController
  before_action :redirect_to_primary_host, only: :index
  before_action :track_referrer, only: :index

  def index; end

  def track_referrer
    return if params[:ref].blank?

    AnalyticsService.call(event_type: :referral,
                          cookies:,
                          assessment_code:,
                          page: params[:ref])
    redirect_to root_path(params.except(:ref, :action, :controller).permit!)
  end
end
