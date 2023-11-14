class QuestionFlowController < ApplicationController
  before_action :load_check

  def show
    track_page_view
    @form = Flow::Handler.model_from_session(step, session_data)
    render "/question_flow/#{step}"
  end

protected

  def load_check
    @check = Check.new(session_data)
  end

  def assessment_code
    params[:assessment_code].presence
  end

  def next_check_answer_step(step)
    Steps::Helper.remaining_steps_for(session_data, step)
      .drop_while { |thestep|
        Flow::Handler.model_from_session(thestep, session_data).valid?
      }.first
  end

  def page_name
    step
  end

  def track_choices(form)
    ChoiceAnalyticsService.call(form, assessment_code, cookies)
  end

  def step
    @step ||= Flow::Handler.step_from_url_fragment(params[:step_url_fragment])
  end

  def tag_from(step)
    Flow::Handler::STEPS.fetch(step)[:tag]
  end
end
