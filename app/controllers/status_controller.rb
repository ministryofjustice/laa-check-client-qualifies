class StatusController < ApplicationController
  # This is used by the liveness check, used to see if a pod needs replacing
  def index
    if HealthCheckService.call(check_cfe: false)
      render json: { alive: true }
    else
      render json: { alive: false }, status: :service_unavailable
    end
  end

  # This is used by the readiness check, used to see if a pod is ready to start receiving traffic
  def health
    if HealthCheckService.call(check_cfe: true)
      render json: { healthy: true }
    else
      render json: { healthy: false }, status: :service_unavailable
    end
  end
end
