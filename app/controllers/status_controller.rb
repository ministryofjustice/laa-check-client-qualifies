class StatusController < ApplicationController
  skip_before_action :authenticate, :check_maintenance_mode, only: :index

  def index
    render json: { alive: true }
  end

  def health
    if HealthCheckService.call
      render json: { healthy: true }
    else
      render json: { healthy: false }, status: :service_unavailable
    end
  end
end
