class AnalyticsService
  ALLOWED_EVENT_TYPE = YAML.load_file(
    Rails.root.join("config/allowed_analytics_event_types.yml"),
  )["allowed_event_types"].freeze

  ALLOWED_PAGES = YAML.load_file(
    Rails.root.join("config/allowed_analytics_pages.yml"),
  )["allowed_pages"].freeze

  class << self
    def call(event_type:, page:, assessment_code:, cookies:)
      return if cookies[CookiesController::NO_ANALYTICS_MODE]
      return unless valid_event_type?(event_type)
      return unless valid_page?(page)

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

  private

    def valid_event_type?(event_type)
      ALLOWED_EVENT_TYPE.include?(event_type.to_s)
    end

    def valid_page?(page)
      ALLOWED_PAGES.include?(page.to_s)
    end
  end
end
