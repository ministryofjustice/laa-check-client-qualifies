source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.0"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft", ">= 0.9.0"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Add gems for sentry error reporting
gem "sentry-ruby"
gem "sentry-rails", ">= 5.18.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "grover"

gem "exception_notification"
gem "govuk_notify_rails", "~> 2.2.0"

gem "geckoboard-ruby"

gem "pdf-forms"
gem "rexml"
gem "factory_bot_rails"

gem "hexapdf"

gem "devise"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection", ">= 1.0.2"
gem "omniauth-saml", "~> 2.1.0"

gem "rails_admin"

group :development, :test do
  gem "annotate_models"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "dotenv-rails", ">= 3.1.1"
  gem "rspec_junit_formatter"
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "pry-nav"

  gem "simplecov", require: false
  gem "slim_lint"
  gem "rubocop-govuk", require: false
  gem "rubocop-performance"
  gem "erb_lint"
  gem "parallel_tests"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "faker"
  gem "rspec"
  gem "selenium-webdriver"
  gem "capybara-selenium"
  gem "webmock", require: false
  gem "axe-core-rspec"
  gem "rack_session_access"
  gem "database_cleaner"
  gem "vcr", require: false
end

gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "faraday"
gem "faraday-net_http_persistent"
gem "faraday-retry"
gem "slim-rails"
gem "redis-rails"
