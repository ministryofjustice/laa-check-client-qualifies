module Cfe
  class AssessmentPayloadService < BaseService
    def call
      form = LevelOfHelpForm.from_session(@session_data)
      assessment = {
        submission_date: Time.zone.today,
        level_of_help: form.level_of_help,
      }
      payload[:assessment] = assessment
    end
  end
end
