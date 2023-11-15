class ChecksController < ApplicationController
  before_action :redirect_to_primary_host, only: :new

  def new
    new_assessment_code = SecureRandom.uuid
    session[assessment_id(new_assessment_code)] = { "feature_flags" => FeatureFlags.session_flags }
    redirect_to helpers.step_path_from_step(Steps::Helper.first_step, new_assessment_code)
  end

  def check_answers
    @check = Check.new(session_data)
    @sections = CheckAnswers::SectionListerService.call(session_data)
    track_page_view(page: :check_answers)
  end

  def assessment_code
    params[:assessment_code]
  end
end
