class QuestionFlowController < ApplicationController
  include QuestionFlowMethods

  before_action :load_check

  def show
    track_page_view
    @previous_step = Steps::Helper.previous_step_for(session_data, step)
    @form = Flow::Handler.form_from_session(step, session_data)
    render "/question_flow/#{step}"
  end
end
