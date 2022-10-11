class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path cfe_connection.create_assessment_id
  end

  def create
    # The last thing to do before retrieving the result is to tell CFE
    # about the applicant
    create_applicant

    @model = cfe_connection.api_result(params[:cfe_id])

    render :show
  end

  def create_applicant
    estimate = Flow::ApplicantHandler.model(session_data(params[:cfe_id]))
    cfe_connection.create_applicant params[:cfe_id],
                                    date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                    receives_qualifying_benefit: estimate.passporting
  end
end
