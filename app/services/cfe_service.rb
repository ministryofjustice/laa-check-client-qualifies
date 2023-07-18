class CfeService
  class << self
    def call(session_data)
      payload = {}
      Cfe::AssessmentPayloadService.call(session_data, payload)
      Cfe::DependantsPayloadService.call(session_data, payload)
      Cfe::ProceedingsPayloadService.call(session_data, payload)
      Cfe::EmploymentIncomePayloadService.call(session_data, payload)
      Cfe::IrregularIncomePayloadService.call(session_data, payload)
      Cfe::VehiclePayloadService.call(session_data, payload)
      Cfe::AssetsPayloadService.call(session_data, payload)
      Cfe::RegularTransactionsPayloadService.call(session_data, payload)
      Cfe::ApplicantPayloadService.call(session_data, payload)
      Cfe::PartnerPayloadService.call(session_data, payload)
      CfeConnection.assess(payload)
    end
  end
end
