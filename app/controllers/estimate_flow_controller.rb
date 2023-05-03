class EstimateFlowController < ApplicationController
  include Wicked::Wizard
  before_action :load_check

  steps(*Steps::Helper.all_possible_steps)

  def show
    track_page_view
    @form = Flow::Handler.model_from_session(step, session_data)
    render_wizard
  end

protected

  def load_check
    @check = Check.new(session_data)
  end

  def assessment_code
    params[:estimate_id]
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
end
