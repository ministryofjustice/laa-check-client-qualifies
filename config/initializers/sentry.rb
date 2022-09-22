sentry_dsn = Rails.configuration.sentry_dsn
if %w[production].include?(Rails.env) && sentry_dsn.present?
  Sentry.init do |config|
    config.dsn = sentry_dsn
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # there are no fields to sanitize at present if/when we do, they should be added to the list here:
    # config/initializers/filter_parameter_logging.rb
    # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 0.2
  end
end
