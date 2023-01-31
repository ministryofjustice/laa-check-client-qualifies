class SubmitProceedingsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = ApplicantForm.from_session(cfe_session_data)
    proceeding_type = form.proceeding_type || ApplicantForm::PROCEEDING_TYPES[:other]
    cfe_connection.create_proceeding_type(cfe_estimate_id, proceeding_type)
  end
end
