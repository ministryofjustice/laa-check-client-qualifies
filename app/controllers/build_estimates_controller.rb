class BuildEstimatesController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  steps(*STEPS_WITH_PROPERTY)

  HANDLER_CLASSES = {
    intro: Flow::IntroHandler,
    monthly_income: Flow::IncomeHandler,
    property: Flow::PropertyHandler,
    vehicle: Flow::VehicleHandler,
    assets: Flow::AssetHandler,
    summary: Flow::SummaryHandler,
    outgoings: Flow::OutgoingsHandler,
    property_entry: Flow::PropertyEntryHandler,
  }.freeze

  def show
    handler = HANDLER_CLASSES[step]
    @form = if handler
              handler.model(session_data)
            else
              cfe_connection.api_result(estimate_id)
            end
    @estimate = load_estimate
    render_wizard
  end

  def update
    handler = HANDLER_CLASSES[step]
    @form = handler.form(params)

    if @form.valid?
      if step == :summary
        estimate = load_estimate
        cfe_connection.create_applicant estimate_id,
                                        date_of_birth: estimate.over_60 ? 61.years.ago.to_date : 59.years.ago.to_date,
                                        receives_qualifying_benefit: estimate.passporting
        session.delete(session_key)
        redirect_to next_wizard_path
      else
        save_data(@form)
        estimate = load_estimate

        redirect_to wizard_path next_step_for(estimate, step)
      end
    else
      @estimate = load_estimate
      render_wizard
    end
  end

private

  def load_estimate
    EstimateData.new session_data.slice(*EstimateData::ESTIMATE_ATTRIBUTES.map(&:to_s))
  end

  def save_data(form)
    handler = HANDLER_CLASSES[step]

    case step
    when :outgoings
      handler.save_data(cfe_connection, estimate_id, Flow::IncomeHandler.model(session_data), form)
    else
      handler.save_data(cfe_connection, estimate_id, form, nil)
    end
    session_data.merge!(form.attributes)
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
