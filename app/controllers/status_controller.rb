class StatusController < ApplicationController
  skip_before_action :authenticate, :check_maintenance_mode, only: %i[index health]

  def index
    render json: { alive: true }
  end

  def health
    healthy, error = HealthCheckService.call
    if healthy
      render json: { healthy: true }
    else
      render json: { healthy: false, error: }
    end
  end
end
