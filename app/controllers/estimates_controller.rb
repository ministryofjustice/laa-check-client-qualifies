class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path SecureRandom.uuid
  end

  def create
    @model = CfeService.call(cfe_session_data)
    @asset_model = Flow::AssetHandler.model(cfe_session_data)
    render :show
  end

  def print
    # TODO: At the moment api_result cannot be called twice with the same ID
    # Therefore this page cannot be accessed after the `create` page has been accessed.
    @model = cfe_connection.api_result(params[:id])
    @asset_model = Flow::AssetHandler.model(cfe_session_data)

    render :print, layout: "print_application"
  end

private

  def cfe_session_data
    session_data params[:estimate_id]
  end
end
