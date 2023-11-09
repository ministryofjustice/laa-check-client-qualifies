# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Add additional requires below this line. Rails is not loaded until this point!
require "unused_i18n_key_checker"
require "rspec/rails"
require "axe-rspec"
require "pry-rescue/rspec" if Rails.env.development?

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   puts e.to_s.strip
#   exit 1
# end

ALLOWED_HOSTS = ["https://chromedriver.storage.googleapis.com",
                 "https://github.com"].freeze

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  WebMock.disable_net_connect!(allow_localhost: true, allow: ALLOWED_HOSTS)
  config.around(:each, :vcr) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!(allow_localhost: true, allow: ALLOWED_HOSTS)
  end

  config.after(:each, type: :system) do
    errors = page.driver.browser.logs.get(:browser)
    if errors.present?
      aggregate_failures "javascript errors" do
        errors.map { { level: _1.level, message: _1.message } }.uniq.each do |error|
          expect(error[:level]).not_to eq("SEVERE"), error[:message]

          next unless error[:level] == "WARNING"

          warn "WARN: javascript output a warning"
          warn error[:message]
        end
      end
    end
  end

  config.around(:each, :index_production_flag) do |example|
    ENV["INDEX_PRODUCTION_FEATURE_FLAG"] = "enabled"
    example.run
    ENV["INDEX_PRODUCTION_FEATURE_FLAG"] = "disabled"
  end

  config.around(:each, :maintenance_mode_flag) do |example|
    ENV["MAINTENANCE_MODE_FEATURE_FLAG"] = "enabled"
    example.run
    ENV["MAINTENANCE_MODE_FEATURE_FLAG"] = "disabled"
  end

  config.around(:each, :basic_authentication_flag) do |example|
    ENV["BASIC_AUTHENTICATION_FEATURE_FLAG"] = "enabled"
    example.run
    ENV["BASIC_AUTHENTICATION_FEATURE_FLAG"] = "disabled"
  end

  config.around(:each, :welsh_cw_flag) do |example|
    ENV["WELSH_CW_FEATURE_FLAG"] = "enabled"
    example.run
    ENV["WELSH_CW_FEATURE_FLAG"] = "disabled"
  end

  config.around(:each, :end_of_journey) do |example|
    ENV["END_OF_JOURNEY_FEATURE_FLAG"] = "enabled"
    example.run
    ENV["END_OF_JOURNEY_FEATURE_FLAG"] = "disabled"
  end

  config.around(:each, :under_eighteen_flag) do |example|
    ENV["UNDER_EIGHTEEN_FEATURE_FLAG"] = "enabled"
    example.run
    ENV["UNDER_EIGHTEEN_FEATURE_FLAG"] = "disabled"
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end
  config.after(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.after(:suite) do
    UnusedI18nKeyChecker.check_unused_keys(
      # These are parts of the translation file where we know the test suite doesn't cover all useable text
      ignore: [
        "activemodel.errors",
        "checks.check_answers.employment_fields.frequency_options",
        "checks.check_answers.partner_employment_fields.partner_frequency_options",
        "results.show.controlled_",
        "results.show.property_rows.main_home_disregard.text",
        "results.show.property_rows.equity.partial_partner_hint",
        "results.show.capital_header.partner.first_controlled",
        "results.show.ineligible_explanation",
      ],
    )
  end

  config.include ActiveSupport::Testing::TimeHelpers
end

Capybara.configure do |config|
  # Allow us to use the `choose(label_text)` method in browser tests
  # even when the radio button element attached to the label is hidden
  # (as it is using the standard govuk radio element)
  config.automatic_label_click = true
end
