# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "axe-rspec"
# Add additional requires below this line. Rails is not loaded until this point!

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
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

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

  WebMock.disable_net_connect!(allow_localhost: true)
  config.around(:each, :vcr) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.include ActiveSupport::Testing::TimeHelpers
end

# require 'vcr'

# the default is :once, which seems to mess-up our cassette re-use
# set VCR=1 when you wish to record new interactions with T3 (hopefully never)
# set VCR=2 when the world changes dramatically e.g. new host, change API
RECORD_MODES = {0 => :none, 1 => :new_episodes, 2 => :all}.freeze
ACCEPT_HEADERS = ["Accept"].freeze

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  # using this higher-level hook allows WebMock to write-out stub calls when not in VCR-mode
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  # weirdly this assignment is implemented as a merge in VCR, so it only
  # overwrites the specified configuration options
  config.default_cassette_options = {
    record: RECORD_MODES.fetch(ENV.fetch("VCR", "0").to_i),
    match_requests_on: [
      :method,
      :uri,
      :body,
      :accept_headers_with_version
    ]
  }

  # CFE version info is in the accept header - so if the accept header is different, it is a different request
  config.register_request_matcher :accept_headers_with_version do |r1, r2|
    r1_headers = r1.headers.select { |k, _| ACCEPT_HEADERS.include?(k) }
    r2_headers = r2.headers.select { |k, _| ACCEPT_HEADERS.include?(k) }

    r1_headers == r2_headers
  end
end
