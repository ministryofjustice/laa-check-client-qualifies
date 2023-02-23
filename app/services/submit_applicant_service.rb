class SubmitApplicantService < BaseCfeService
  def call(cfe_assessment_id, session_data)
    estimate = ApplicantForm.from_session(session_data)
    asylum_support_form = AsylumSupportForm.from_session(session_data)

    base_attributes = {
      date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
      has_partner_opponent: false,
      receives_qualifying_benefit: estimate.passporting || false,
      employed: estimate.employed || false,
    }

    applicant = if FeatureFlags.enabled?(:asylum_and_immigration)
                  base_attributes.merge({ receives_asylum_support: asylum_support_form.asylum_support || false })
                else
                  base_attributes
                end

    cfe_connection.create_applicant(cfe_assessment_id, applicant)
  end
end
