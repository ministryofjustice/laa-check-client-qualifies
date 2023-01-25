class SubmitProceedingsService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = ApplicantForm.from_session(cfe_session_data)
    cfe_connection.create_proceeding_type(cfe_estimate_id, form.proceeding_type)
    #  make this condtional on certificated/controlled to reduce calls if possible
  end
end
