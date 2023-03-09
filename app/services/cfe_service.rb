class CfeService
  class << self
    def call(session_data)
      cfe_connection = CfeConnection.connection
      cfe_assessment_id = create_assessment_id(cfe_connection, session_data)
      SubmitDependantsService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitProceedingsService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitEmploymentIncomeService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitBenefitsService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitIrregularIncomeService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitVehicleService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitAssetsService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitRegularTransactionsService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitApplicantService.call(cfe_connection, cfe_assessment_id, session_data)
      SubmitPartnerService.call(cfe_connection, cfe_assessment_id, session_data)
      result(cfe_connection, cfe_assessment_id, session_data)
    end

    def create_assessment_id(cfe_connection, session_data)
      attributes = { submission_date: Time.zone.today }
      form = LevelOfHelpForm.from_session(session_data)
      attributes[:level_of_help] = form.level_of_help if form.level_of_help.present?
      cfe_connection.create_assessment_id(attributes)
    end

    def result(cfe_connection, cfe_assessment_id, session_data)
      cfe_connection.api_result(cfe_assessment_id).tap do |calculation_result|
        calculation_result.level_of_help = session_data.fetch("level_of_help", "certificated")
      end
    end
  end
end
