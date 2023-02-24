class AnalyticsService
  class << self
    def call(event_type:, page:, assessment_code:, browser_id:)
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
