class CfeService
  class << self
    def call(session_data, relevant_steps)
      payload = {}
      Cfe::AssessmentPayloadService.call(session_data, payload, relevant_steps)
      Cfe::DependantsPayloadService.call(session_data, payload, relevant_steps)
      Cfe::ProceedingsPayloadService.call(session_data, payload, relevant_steps)
      Cfe::EmploymentIncomePayloadService.call(session_data, payload, relevant_steps)
      Cfe::IrregularIncomePayloadService.call(session_data, payload, relevant_steps)
      Cfe::VehiclePayloadService.call(session_data, payload, relevant_steps)
      Cfe::AssetsPayloadService.call(session_data, payload, relevant_steps)
      Cfe::RegularTransactionsPayloadService.call(session_data, payload, relevant_steps)
      Cfe::ApplicantPayloadService.call(session_data, payload, relevant_steps)
      Cfe::PartnerPayloadService.call(session_data, payload, relevant_steps)
      CfeConnection.assess(payload)
    end

    def result(session_data, completed_steps)
      CfeResult.new call(session_data, completed_steps)
    end
  end
end
