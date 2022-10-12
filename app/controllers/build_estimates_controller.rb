class BuildEstimatesController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  steps(*ALL_POSSIBLE_STEPS)

  HANDLER_CLASSES = {
    applicant: Flow::ApplicantHandler,
    employment: Flow::EmploymentHandler,
    monthly_income: Flow::MonthlyIncomeHandler,
    property: Flow::PropertyHandler,
    vehicle: Flow::Vehicle::OwnedHandler,
    vehicle_value: Flow::Vehicle::ValueHandler,
    vehicle_age: Flow::Vehicle::AgeHandler,
    vehicle_finance: Flow::Vehicle::FinanceHandler,
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
      session_data.merge!(@form.attributes)
      estimate = load_estimate
      handler.save_data(cfe_connection, estimate_id, @form, session_data) if last_step_in_group?(estimate, step)

      redirect_to wizard_path next_step_for(estimate, step)
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
