class SubmitApplicantService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    estimate = Flow::ApplicantHandler.model(cfe_session_data)

    cfe_connection.create_applicant cfe_estimate_id,
                                    date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                    receives_qualifying_benefit: estimate.passporting
  end
end
