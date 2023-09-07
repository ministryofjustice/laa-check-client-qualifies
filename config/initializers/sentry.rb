sentry_dsn = Rails.configuration.sentry_dsn
if sentry_dsn.present? && ENV["SENTRY_FEATURE_FLAG"]&.casecmp("enabled")&.zero?
  Sentry.init do |config|
    config.dsn = sentry_dsn
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # there are no fields to sanitize at present if/when we do, they should be added to the list here:
    # config/initializers/filter_parameter_logging.rb
    # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

    # Capture 10% of all regular traffic, but only 1% of status check traffic
    # (there are lots and lots of status checks, and we want to know if there are
    # problems but we don't want to clog up Sentry with data)
    config.traces_sampler = lambda do |sampling_context|
      /\A\/(status|health)\z/.match?(sampling_context[:env]["PATH_INFO"]) ? 0.01 : 0.1
    end
  end
end
