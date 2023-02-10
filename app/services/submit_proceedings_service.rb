class SubmitProceedingsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    applicant_form = ApplicantForm.from_session(cfe_session_data)
    tribunal_form = TribunalForm.from_session(cfe_session_data)
    proceeding_type = if applicant_form.level_of_help == "certificated"
                        applicant_form.proceeding_type
                      elsif tribunal_form.upper_tribunal
                        matter_type_form = MatterTypeForm.from_session(cfe_session_data)
                        matter_type_form.upper_tribunal_proceeding_type
                      else
                        ApplicantForm::PROCEEDING_TYPES[:other]
                      end
    cfe_connection.create_proceeding_type(cfe_estimate_id, proceeding_type)
  end
end
