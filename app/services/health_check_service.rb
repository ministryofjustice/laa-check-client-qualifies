class HealthCheckService
  def self.call
    database_healthy? && short_term_persistence_healthy?
  rescue StandardError
    false
  end

  def self.database_healthy?
    ActiveRecord::Base.connection.active?
  rescue PG::ConnectionBad, PG::UndefinedTable
    false
  end

  def self.short_term_persistence_healthy?
    Rails.cache.write("_health_check_", "ok", expires_in: 5.seconds) &&
      Rails.cache.read("_health_check_") == "ok"
  end
end
