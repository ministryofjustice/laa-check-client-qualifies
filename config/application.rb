require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

require "grover"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LaaEstimateFinancialEligibilityForLegalAid
  SESSION_COOKIE_NAME = "SessionData".freeze

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.assets.paths << Rails.root.join("node_modules/govuk-frontend/govuk/assets")

    config.sentry_dsn = ENV["SENTRY_DSN"]&.strip
    config.check_financial_eligibility_host = ENV.fetch("CFE_HOST",
                                                        "https://check-financial-eligibility-partner-staging.cloud-platform.service.justice.gov.uk/")

    config.middleware.use Grover::Middleware
  end
end
