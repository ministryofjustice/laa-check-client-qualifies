class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path SecureRandom.uuid
  end

  def create
    cfe_estimate_id
    CfeService.call(cfe_estimate_id, cfe_session_data)
    @model = cfe_connection.api_result(cfe_estimate_id)

    render :show
  end

  private

  def cfe_estimate_id
    @cfe_estimate_id ||= cfe_connection.create_assessment_id
  end

  def cfe_session_data
    session_data params[:cfe_id]
  end
end
