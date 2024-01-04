class CfeService
  class << self
    def call(*args)
      payload = {}
      Cfe::AssessmentPayloadService.call(*args, payload)
      Cfe::DependantsPayloadService.call(*args, payload)
      Cfe::ProceedingsPayloadService.call(*args, payload)
      Cfe::EmploymentIncomePayloadService.call(*args, payload)
      Cfe::IrregularIncomePayloadService.call(*args, payload)
      Cfe::VehiclePayloadService.call(*args, payload)
      Cfe::AssetsPayloadService.call(*args, payload)
      Cfe::RegularTransactionsPayloadService.call(*args, payload)
      Cfe::ApplicantPayloadService.call(*args, payload)
      Cfe::PartnerPayloadService.call(*args, payload)
      CfeConnection.assess(payload)
    end
  end
end
