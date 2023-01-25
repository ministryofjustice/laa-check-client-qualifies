class CfeService
  class << self
    def call(cfe_session_data)
      puts ">>>>>>>>>  #{__FILE__}:#{__LINE__} <<<<<<<<<<"
      puts 111111
      cfe_connection = CfeConnection.connection
      puts ">>>>>>>>>  #{__FILE__}:#{__LINE__} <<<<<<<<<<"
      puts 222222
      cfe_estimate_id = cfe_connection.create_assessment_id
      puts ">>>>>>>>>  #{__FILE__}:#{__LINE__} <<<<<<<<<<"
      puts 333333333
      Async do |task|
        SERVICES.each do |service|
          task.async { service.call(cfe_connection, cfe_estimate_id, cfe_session_data) }
        end
      end
      puts ">>>>>>>>>  #{__FILE__}:#{__LINE__} <<<<<<<<<<"
      puts 5555
      cfe_connection.api_result(cfe_estimate_id)
    end

    SERVICES = [
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
  end
end

# SubmitDependantsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitProceedingsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitEmploymentIncomeService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitBenefitsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitIrregularIncomeService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitVehicleService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitAssetsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitRegularTransactionsService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitApplicantService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
# SubmitPartnerService.call(cfe_connection, cfe_estimate_id, cfe_session_data)
