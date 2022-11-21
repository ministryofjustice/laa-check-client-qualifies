class SubmitProceedingsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = ProceedingTypeForm.from_session(cfe_session_data)
    cfe_connection.create_proceeding_type(cfe_estimate_id, form.proceeding_type)
  end
end
