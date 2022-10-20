class EstimateFlowController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  def show
    handler = handler_classes[step]
    if handler
      @form = handler.model(session_data)
      @estimate = load_estimate
    end
    render_wizard
  end

  def update
    handler = handler_classes.fetch(step)
    @form = handler.form(params, session_data)

    if @form.valid?
      session_data.merge!(@form.attributes)
      handler.save_data(cfe_connection, estimate_id, @form, session_data)

      redirect_to next_wizard_path
    else
      @estimate = load_estimate
      render_wizard
    end
  end

  protected

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
