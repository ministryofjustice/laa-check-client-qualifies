class ServiceUnavailableController < ApplicationController
  def index
    render file: Rails.root.join("public/service_unavailable.html"), status: :service_unavailable
  end
end
