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

    def ineligible_gross_income?(session_data, completed_steps)
      early_result = call(session_data, completed_steps)

      # guard clause here for cases where there is no proceeding type i.e. under 18?
      # This issue can arise in a change loop.
      # TODO: this branch doesn't seem to be necessary?
      return false if early_result.dig("result_summary", "gross_income", "proceeding_types").compact_blank.blank?

      early_result.dig("result_summary", "gross_income", "proceeding_types").first["result"] == "ineligible"
    end
  end
end
