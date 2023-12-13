module Cfe
  class AssessmentPayloadService < BaseService
    def call
      form = instantiate_form(LevelOfHelpForm)
      assessment = {
        submission_date: Time.zone.today,
        level_of_help: form.level_of_help,
      }

      assessment[:controlled_legal_representation] = check.controlled_legal_representation if relevant_form?(:under_18_clr)
      assessment[:not_aggregated_no_income_low_capital] = check.not_aggregated_no_income_low_capital? if relevant_form?(:aggregated_means)
      payload[:assessment] = assessment
    end
  end
end
