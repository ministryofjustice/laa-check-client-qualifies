class AnalyticsService
  ALLOWED_PAGES = YAML.load_file(
    Rails.root.join("config/allowed_analytics_pages.yml"),
  )["allowed_pages"].freeze

  class << self
    def call(event_type:, page:, assessment_code:, cookies:)
      return if cookies[CookiesController::NO_ANALYTICS_MODE]
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

    def valid_page?(page)
      ALLOWED_PAGES.include?(page)
    end
  end
end
