class InstantSessionsController < ApplicationController
  def create
    data = case params[:session_type]
           when "controlled"
             FactoryBot.build(:instant_controlled_session)
           when "certificated"
             FactoryBot.build(:instant_certificated_session)
           else
             raise "Unknown session type requested: #{params[:session_type]}"
           end
    session[assessment_id] = data
    redirect_to check_answers_estimate_path assessment_code
  end

  def assessment_code
    @assessment_code ||= SecureRandom.uuid
  end
end
