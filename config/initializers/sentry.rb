Sentry.init do |config|
  # config.dsn = ENV['SENTRY_DSN']
  config.dsn = "https://04ec9fc34a2146138f8a2da2d243a718@o345774.ingest.sentry.io/6747538"
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # there are no fields to sanitize at present if/when we do, they should be added to the list here:
  # config/initializers/filter_parameter_logging.rb
  # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 0.2
end
