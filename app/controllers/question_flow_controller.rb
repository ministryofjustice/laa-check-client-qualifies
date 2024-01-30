class QuestionFlowController < ApplicationController
  before_action :load_check

  def show
    track_page_view
    @form = Flow::Handler.model_from_session(step, session_data)
    @show_banner = change_answers_loop? && @form.class.from_session(session_data).invalid? && FeatureFlags.enabled?(:early_eligibility, session_data)
    session_data["banner_seen"] = true if @show_banner # this line doesn't yet work
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

  def change_answers_loop?
    params[:controller] == "change_answers"
  end
end
