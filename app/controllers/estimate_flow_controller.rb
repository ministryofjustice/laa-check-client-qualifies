class EstimateFlowController < ApplicationController
  include Wicked::Wizard

  steps(*StepsHelper.all_possible_steps)

  def show
    track_page_view
    @form = Flow::Handler.model_from_session(step, session_data)
    @estimate = load_estimate
    render_wizard
  end

protected

  def load_estimate
    EstimateModel.from_session(session_data)
  end

  def assessment_code
    params[:estimate_id]
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
