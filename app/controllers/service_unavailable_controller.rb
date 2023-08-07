class ServiceUnavailableController < ApplicationController
  def index
    render file: Rails.root.join("public/500.html"), status: :service_unavailable
  end
end
