class CfeService
  class << self
    CFE_SERVICES = [
      SubmitDependantsService,
      SubmitProceedingsService,
      SubmitEmploymentIncomeService,
      SubmitBenefitsService,
      SubmitIrregularIncomeService,
      SubmitVehicleService,
      SubmitAssetsService,
      SubmitRegularTransactionsService,
      SubmitApplicantService,
      SubmitPartnerService,
    ].freeze

    def call(cfe_session_data)
      cfe_connection = CfeConnection.connection
      cfe_estimate_id = cfe_connection.create_assessment_id
      Async do |task|
        CFE_SERVICES.each do |service|
          task.async { service.call(cfe_connection, cfe_estimate_id, cfe_session_data) }
        end
      end
      cfe_connection.api_result(cfe_estimate_id)
    end
  end
end
