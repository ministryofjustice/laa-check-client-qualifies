module Cfe
  class AssessmentPayloadService < BaseService
    def call
      form = instantiate_form(LevelOfHelpForm)
      assessment = {
        submission_date: Time.zone.today,
        level_of_help: form.level_of_help,
      }
      payload[:assessment] = assessment
    end
  end
end
