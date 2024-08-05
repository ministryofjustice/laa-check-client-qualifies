module Cfe
  class AssessmentPayloadService
    class << self
      def call(session_data, payload)
        form = BaseService.instantiate_form(session_data, LevelOfHelpForm)
        check = Check.new session_data
        assessment = {
          submission_date: Time.zone.today,
          level_of_help: form.level_of_help,
        }

        assessment[:controlled_legal_representation] = check.controlled_legal_representation if check.under_eighteen? && check.controlled?
        assessment[:not_aggregated_no_income_low_capital] = check.not_aggregated_no_income_low_capital? if check.under_eighteen? && check.controlled? && !check.under_18_controlled_clr?

        payload[:assessment] = assessment
      end
    end
  end
end
