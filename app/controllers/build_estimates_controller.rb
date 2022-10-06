class BuildEstimatesController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  steps(*STEPS_WITH_PROPERTY)

  HANDLER_CLASSES = {
    applicant: Flow::ApplicantHandler,
    monthly_income: Flow::MonthlyIncomeHandler,
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
    handler = HANDLER_CLASSES.fetch(step)
    @form = handler.form(params, session_data)

    if @form.valid?
      handler.save_data(cfe_connection, estimate_id, @form, session_data)
      # TODO: having multiple estimates stored in the same session will
      # eventually cause a CookieOverflow error as more and more data is added
      # to each estimate
      session_data.merge!(@form.attributes)

      redirect_to wizard_path next_step_for(load_estimate, step)
    else
      @estimate = load_estimate
      render_wizard
    end
  end

private

  def load_estimate
    EstimateData.new session_data.slice(*EstimateData::ESTIMATE_ATTRIBUTES.map(&:to_s))
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
