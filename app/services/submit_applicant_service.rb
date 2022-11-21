class SubmitApplicantService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = ApplicantForm.from_session(cfe_session_data)

    cfe_connection.create_applicant cfe_estimate_id,
                                    date_of_birth: form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                    receives_qualifying_benefit: form.passporting
  end
end
