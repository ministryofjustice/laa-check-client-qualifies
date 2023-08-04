class MaintenanceController < ApplicationController
  def index
    render file: Rails.root.join("public/maintenance.html"), status: :service_unavailable
  end
end
