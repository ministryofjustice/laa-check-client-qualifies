class CfeService
  class << self
    def call(cfe_session_data)
      cfe_connection = CfeConnection.connection
      cfe_estimate_id = cfe_connection.create_assessment_id
      SubmitDependantsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitProceedingsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitEmploymentIncomeService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitBenefitsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitIrregularIncomeService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitVehicleService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitAssetsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitRegularTransactionsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitApplicantService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      SubmitPartnerService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
      cfe_connection.api_result(cfe_estimate_id)
    end
  end
end
