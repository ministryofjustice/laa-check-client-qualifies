class SubmitApplicantService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    estimate = ApplicantForm.from_session(session_data)

    applicant = {
      date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
      has_partner_opponent: false,
      receives_qualifying_benefit: estimate.passporting,
      employed: estimate.employed,
    }

    cfe_connection.create_applicant(cfe_assessment_id, applicant)
  end
end
