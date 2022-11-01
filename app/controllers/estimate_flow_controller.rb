class EstimateFlowController < ApplicationController
  include Wicked::Wizard

  steps(*StepsHelper.all_possible_steps)

  HANDLER_CLASSES = {
    case_details: Flow::CaseDetailsHandler,
    applicant: Flow::ApplicantHandler,
    dependants: Flow::DependantsHandler,
    dependant_details: Flow::DependantDetailsHandler,
    employment: Flow::EmploymentHandler,
    benefits: Flow::BenefitsHandler,
    monthly_income: Flow::MonthlyIncomeHandler,
    property: Flow::PropertyHandler,
    vehicle: Flow::Vehicle::OwnedHandler,
    vehicle_details: Flow::Vehicle::DetailsHandler,
    assets: Flow::AssetHandler,
    check_answers: Flow::CheckAnswersHandler,
    outgoings: Flow::OutgoingsHandler,
    property_entry: Flow::PropertyEntryHandler,
  }.freeze

  def show
    handler = HANDLER_CLASSES.fetch(step)
    @form = handler.model(session_data)
    @estimate = load_estimate
    render_wizard
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
