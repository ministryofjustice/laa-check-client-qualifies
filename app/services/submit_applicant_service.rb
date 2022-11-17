class SubmitApplicantService < BaseCfeService
  def call(cfe_estimate_id, cfe_session_data)
    form = ApplicantForm.from_session(cfe_session_data)

    applicant = {
      date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
      has_partner_opponent: false,
      receives_qualifying_benefit: estimate.passporting,
      employed: estimate.employed,
    }

    cfe_connection.create_applicant(cfe_estimate_id, applicant)
  end
end
