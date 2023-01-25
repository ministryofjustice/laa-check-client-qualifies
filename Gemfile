source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# gem used to asynchronously call CFE
gem "async"

# Use postgresql as the database for Active Record
# gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

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
gem "sentry-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "flipper"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "dotenv-rails"
  gem "factory_bot_rails"

  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "pry-nav"

  gem "simplecov", require: false
  gem "slim_lint"
  gem "rubocop-govuk", require: false
  gem "rubocop-performance"
  gem "erb_lint"
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
  gem "rspec"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "capybara-selenium"
  gem "vcr", require: false
  gem "webmock", require: false
  gem "axe-core-rspec"
end

gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "wicked"
gem "faraday"
gem "faraday-net_http_persistent"
gem "faraday-retry"
gem "slim-rails"
gem "redis-rails"
