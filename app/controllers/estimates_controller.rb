class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path SecureRandom.uuid
  end

  def create
    @model = CfeService.call(cfe_session_data)

    render :show
  end

private

  def cfe_session_data
    session_data params[:estimate_id]
  end
end
