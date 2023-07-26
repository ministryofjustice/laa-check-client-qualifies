class MetricsService
  def self.call
    return unless ENV["GECKOBOARD_ENABLED"]&.casecmp("enabled")&.zero?

    Metrics::ForKeyMetricDashboardService.call
    Metrics::ForUserJourneyDashboardService.call
  end
end
