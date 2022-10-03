class CheckAnswersController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  steps(*ALL_POSSIBLE_STEPS)

  def show
    handler = BuildEstimatesController::HANDLER_CLASSES.fetch step
    @form = handler.model(session_data)
    @estimate = load_estimate
    render "build_estimates/#{step}"
  end

  def update
    handler = BuildEstimatesController::HANDLER_CLASSES.fetch(step)
    @form = handler.form(params)

    if @form.valid?
      session_data.merge!(@form.attributes)
      estimate = load_estimate
      if last_step_in_group?(estimate, step)
        handler.save_data(cfe_connection, estimate_id, @form, session_data)
        redirect_to estimate_build_estimate_path(estimate_id, :check_answers)
      else
        redirect_to wizard_path next_step_for(estimate, step)
      end
    else
      @estimate = load_estimate
      render "build_estimates/#{step}"
    end
  end

private

  def load_estimate
    EstimateModel.new session_data.slice(*EstimateModel::ESTIMATE_ATTRIBUTES.map(&:to_s))
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
end
