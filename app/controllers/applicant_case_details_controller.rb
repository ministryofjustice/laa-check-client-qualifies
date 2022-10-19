class ApplicantCaseDetailsController < EstimateFlowController
  steps :case_details, :applicant

  HANDLER_CLASSES = {
    case_details: Flow::CaseDetailsHandler,
    applicant: Flow::ApplicantHandler,
  }.freeze

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
end
