class CfeService
  # def self.call(cfe_session_data)
  #   new.call(cfe_session_data)
  # end

  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    SubmitDependantsService.call(cfe_estimate_id, cfe_session_data)
    SubmitProceedingsService.call(cfe_estimate_id, cfe_session_data)
    SubmitEmploymentIncomeService.call(cfe_estimate_id, cfe_session_data)
    SubmitMonthlyIncomeService.call(cfe_estimate_id, cfe_session_data)
    SubmitVehicleService.call(cfe_estimate_id, cfe_session_data)
    SubmitAssetsService.call(cfe_estimate_id, cfe_session_data)
    SubmitOutgoingsService.call(cfe_estimate_id, cfe_session_data)
    SubmitPropertyService.call(cfe_estimate_id, cfe_session_data)
    SubmitApplicantService.call(cfe_estimate_id, cfe_session_data)
    #  output here is the model we will pass out to estimates controller
    #   @model = cfe_connection.api_result(cfe_estimate_id)
  end

private

  def cfe_estimate_id
    @cfe_estimate_id ||= cfe_connection.create_assessment_id
  end

  # Possibly refactor this into a base service, may be overkill as it is the only method that is currently shared across the services
  def cfe_connection
    @cfe_connection ||= CfeConnection.connection
  end
end
