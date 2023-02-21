class AnalyticsService
  class << self
    def call(event_type:, page:, assessment_code:, browser_id:)
      AnalyticsEvent.create(
        event_type:,
        page:,
        assessment_code:,
        browser_id:,
      )
    end
  end
end
