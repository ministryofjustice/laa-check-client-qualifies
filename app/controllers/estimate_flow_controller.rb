class EstimateFlowController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  # steps(*ALL_POSSIBLE_STEPS)
  # steps :applicant_case_details, :income, :capital, :check_answers

  # HANDLER_CLASSES = {
    # case_details: Flow::CaseDetailsHandler,
    # applicant: Flow::ApplicantHandler,
    # incomes: Flow::IncomeHandler,
    # employment: Flow::EmploymentHandler,
    # monthly_income: Flow::MonthlyIncomeHandler,
    # property: Flow::PropertyHandler,
    # vehicle: Flow::Vehicle::OwnedHandler,
    # vehicle_value: Flow::Vehicle::ValueHandler,
    # vehicle_age: Flow::Vehicle::AgeHandler,
    # vehicle_finance: Flow::Vehicle::FinanceHandler,
    # assets: Flow::AssetHandler,
    # check_answers: Flow::CheckAnswersHandler,
    # outgoings: Flow::OutgoingsHandler,
    # property_entry: Flow::PropertyEntryHandler,
  # }.freeze

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
