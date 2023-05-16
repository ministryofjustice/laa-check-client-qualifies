class JourneyLogUpdateService
  class << self
    def call(assessment_id, cookies, new_attributes)
      return if cookies[CookiesController::NO_ANALYTICS_MODE]

      CompletedUserJourney.transaction do
        journey = CompletedUserJourney.find_by!(assessment_id:)
        journey.update!(new_attributes)
      end
    rescue StandardError => e
      ErrorService.call(e)
    end
  end
end
