class SubmitDependantsService < CfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::ApplicantHandler.model(cfe_session_data)
    cfe_connection.create_dependants(cfe_estimate_id, form.dependant_count) if form.dependants
  end
end
