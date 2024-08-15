module Cfe
  class AssessmentPayloadService < BaseService
    def call
      form = instantiate_form(LevelOfHelpForm)
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
