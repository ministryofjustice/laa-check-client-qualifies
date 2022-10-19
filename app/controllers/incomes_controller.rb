class IncomesController < EstimateFlowController

  HANDLER_CLASSES = {
    employment: Flow::EmploymentHandler,
    monthly_income: Flow::MonthlyIncomeHandler,
    outgoings: Flow::OutgoingsHandler,
  }.freeze

  prepend_before_action :decide_steps

  def update
    handler = HANDLER_CLASSES.fetch(step)
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

  def finish_wizard_path
    estimate_build_estimate_path estimate_id, params[:build_estimate_id]
  end

  protected

  def handler_classes
    HANDLER_CLASSES
  end

  private

  def decide_steps
    if load_estimate.employed
      self.steps = [:employment, :monthly_income, :outgoings]
    else
      self.steps = [:monthly_income, :outgoings]
    end
  end
end
