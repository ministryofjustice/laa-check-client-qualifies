class HealthCheckService
  def self.call(check_cfe:)
    database_healthy? && short_term_persistence_healthy? && (!check_cfe || cfe_healthy?)
  rescue StandardError
    false
  end

  def self.database_healthy?
    ActiveRecord::Base.connection.active? && AnalyticsEvent.count.is_a?(Numeric)
  rescue PG::ConnectionBad, PG::UndefinedTable
    false
  end

  def self.short_term_persistence_healthy?
    Rails.cache.write("_health_check_", "ok", expires_in: 5.seconds) &&
      Rails.cache.read("_health_check_") == "ok"
  end

  def self.cfe_healthy?
    # We expect this call to return a hash with at least one key, and every value should be `true`.
    # This shows that every part of itself that CFE considers important is currently healthy.
    healths_collection = CfeConnection.status
    healths_collection.keys.length.positive? && healths_collection.values.all?
  end
end
