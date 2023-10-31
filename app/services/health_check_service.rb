class HealthCheckService
  def self.call
    [ActiveRecord::Base.connection.active?, nil]
  rescue StandardError, PG::ConnectionBad, PG::UndefinedTable => e
    [false, e]
  end
end
