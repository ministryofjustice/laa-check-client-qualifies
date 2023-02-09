class EstimateFlowController < ApplicationController
  include Wicked::Wizard

  steps(*StepsHelper.all_possible_steps)

  def show
    track_page_view(assessment_id: estimate_id)
    @form = Flow::Handler.model_from_session(step, session_data)
    @estimate = load_estimate
    render_wizard
  end

protected

  def load_estimate
    EstimateModel.from_session(session_data)
  end

  def estimate_id
    params[:estimate_id]
  end

  def session_data
    session[session_key] ||= {}
  end

  def session_key
    "estimate_#{estimate_id}"
  end

  def next_check_answer_step(step, model)
    StepsHelper.remaining_steps_for(model, step)
      .drop_while { |thestep|
        Flow::Handler.model_from_session(thestep, session_data).valid?
      }.first
  end

  def page_name
    step
  end
end
