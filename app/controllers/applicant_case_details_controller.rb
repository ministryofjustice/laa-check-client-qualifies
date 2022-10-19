class ApplicantCaseDetailsController < EstimateFlowController
  steps :case_details, :applicant

  HANDLER_CLASSES = {
    case_details: Flow::CaseDetailsHandler,
    applicant: Flow::ApplicantHandler,
  }.freeze

  def finish_wizard_path
    estimate_build_estimate_path estimate_id, params[:build_estimate_id]
  end

  protected

  def handler_classes
    HANDLER_CLASSES
  end
end
