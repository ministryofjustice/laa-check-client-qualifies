class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path create_assessment_id
  end
end
