class AnalyticsService
  class << self
    def call(event_type:, page:, assessment_code: nil, browser_id: nil)
      hash = {
        key: "CCQ Analytics Datum",
        event_type:,
        page:,
        assessment_code:,
        browser_id:,
      }
      Rails.logger.info hash.to_json
    end
  end
end
