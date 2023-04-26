class AnalyticsService
  class << self
    def call(event_type:, page:, assessment_code:, cookies:)
      return if cookies[CookiesController::NO_ANALYTICS_MODE]

      browser_id = cookies[ApplicationController::BROWSER_ID_COOKIE]
      AnalyticsEvent.create!(
        event_type:,
        page:,
        assessment_code:,
        browser_id:,
      )
    rescue StandardError => e
      ErrorService.call(e)
    end
  end
end
