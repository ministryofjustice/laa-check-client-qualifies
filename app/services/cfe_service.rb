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

    def cfe_result(result_body)
      # guard clause here for cases where there is no proceeding type i.e. under 18?
      # This issue can arise in a change loop.
      return "eligible" if result_body.dig("result_summary", "gross_income", "proceeding_types").compact_blank.blank?

      result_body.dig("result_summary", "gross_income", "proceeding_types").first["result"]
    end
  end
end
