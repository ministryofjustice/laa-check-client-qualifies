class MetricsService
  def self.call
    return unless ENV["GECKOBOARD_ENABLED"]&.casecmp("enabled")&.zero?

    Metrics::FromAnalyticsService.call
    Metrics::FromCompletedJourneysService.call
  end
end
