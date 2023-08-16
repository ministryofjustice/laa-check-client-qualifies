class StatusController < ApplicationController
  skip_before_action :authenticate, :check_maintenance_mode, only: :index

  # This is used by both the liveness check, used to see if a pod needs replacing,
  # and the readiness check, used to see if a pod is ready to start receiving traffic
  def index
    if HealthCheckService.call
      render json: { healthy: true }
    else
      render json: { healthy: false }, status: :service_unavailable
    end
  end
end
