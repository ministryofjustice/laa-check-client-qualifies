class CfeService
  class << self
    def call(session_data)
      cfe_connection = CfeConnection.connection
      cfe_assessment_id = create_assessment_id(cfe_connection, session_data)
      Cfe::SubmitDependantsService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitProceedingsService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitEmploymentIncomeService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitBenefitsService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitIrregularIncomeService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitVehicleService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitAssetsService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitRegularTransactionsService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitApplicantService.call(cfe_connection, cfe_assessment_id, session_data)
      Cfe::SubmitPartnerService.call(cfe_connection, cfe_assessment_id, session_data)
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
