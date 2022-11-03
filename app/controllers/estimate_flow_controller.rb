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

  def next_check_answer_step(step, model, session_data)
    steps = Enumerator.new do |yielder|
      next_step = step
      loop do
        next_step = StepsHelper.next_step_for(model, next_step)
        if next_step
          yielder << next_step
        else
          raise StopIteration
        end
      end
    end
    steps.drop_while { |step| HANDLER_CLASSES.fetch(step).model(session_data).valid? }.first
  end
end
