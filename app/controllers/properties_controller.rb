class PropertiesController < EstimateFlowController
  HANDLER_CLASSES = {
    property: Flow::PropertyHandler,
    property_entry: Flow::PropertyEntryHandler,
  }.freeze

  prepend_before_action :all_steps, only: :index
  prepend_before_action :show_decide_steps, only: :show
  prepend_before_action :update_decide_steps, only: :update

  def finish_wizard_path
    estimate_build_estimate_capital_path estimate_id, params[:build_estimate_id], params[:capital_id]
  end

  protected

  def handler_classes
    HANDLER_CLASSES
  end

  private

  def all_steps
    self.steps = [:property, :property_entry]
  end

  def show_decide_steps
    model = load_estimate
    if model.owned?
      self.steps = [:property, :property_entry]
    else
      self.steps = [:property]
    end
  end

  def update_decide_steps
    model = params[:id] == "property" ? Flow::PropertyHandler.form(params, session_data) : load_estimate
    if model.owned?
      self.steps = [:property, :property_entry]
    else
      self.steps = [:property]
    end
  end
end