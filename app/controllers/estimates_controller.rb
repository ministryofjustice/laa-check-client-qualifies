class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path SecureRandom.uuid
  end

  def create
    @model = CfeService.call(cfe_session_data(:estimate_id))
    @asset_model = Flow::AssetHandler.model(cfe_session_data(:estimate_id))
    render :show
  end

  def print
    @model = CfeService.call(cfe_session_data(:id))
    @asset_model = Flow::AssetHandler.model(cfe_session_data(:id))

    render :print, layout: "print_application"
  end

private

  def cfe_session_data(param_name)
    session_data params[param_name]
  end
end
