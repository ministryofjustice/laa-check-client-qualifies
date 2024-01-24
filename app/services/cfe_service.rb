class CfeService
  class << self
    def call(session_data, early_eligibility = nil)
      payload = {}
      Cfe::AssessmentPayloadService.call(session_data, payload, early_eligibility)
      Cfe::DependantsPayloadService.call(session_data, payload, early_eligibility)
      Cfe::ProceedingsPayloadService.call(session_data, payload, early_eligibility)
      Cfe::EmploymentIncomePayloadService.call(session_data, payload, early_eligibility)
      Cfe::IrregularIncomePayloadService.call(session_data, payload, early_eligibility)
      Cfe::VehiclePayloadService.call(session_data, payload, early_eligibility)
      Cfe::AssetsPayloadService.call(session_data, payload, early_eligibility)
      Cfe::RegularTransactionsPayloadService.call(session_data, payload, early_eligibility)
      Cfe::ApplicantPayloadService.call(session_data, payload, early_eligibility)
      Cfe::PartnerPayloadService.call(session_data, payload, early_eligibility)
      CfeConnection.assess(payload)
    end
  end
end
