class CfeService < BaseCfeService
  def self.call(cfe_session_data)
    new.call(cfe_session_data)
  end

  def call(cfe_session_data)
    SubmitDependantsService.call(cfe_estimate_id, cfe_session_data)
    SubmitProceedingsService.call(cfe_estimate_id, cfe_session_data)
    SubmitEmploymentIncomeService.call(cfe_estimate_id, cfe_session_data)
    SubmitBenefitsService.call(cfe_estimate_id, cfe_session_data)
    SubmitIrregularIncomeService.call(cfe_estimate_id, cfe_session_data)
    SubmitVehicleService.call(cfe_estimate_id, cfe_session_data)
    SubmitAssetsService.call(cfe_estimate_id, cfe_session_data)
    SubmitRegularTransactionsService.call(cfe_estimate_id, cfe_session_data)
    SubmitApplicantService.call(cfe_estimate_id, cfe_session_data)
    return_cfe_result(cfe_estimate_id)
  end

private

  def return_cfe_result(cfe_estimate_id)
    cfe_connection.api_result(cfe_estimate_id)
  end

  def cfe_estimate_id
    @cfe_estimate_id ||= cfe_connection.create_assessment_id
  end
end
