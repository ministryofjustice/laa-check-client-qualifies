#!/bin/bash

# Solid Cache SQLite Testing Setup Script
# Run this from the CCQ project root directory

echo "🔧 Setting up Solid Cache with SQLite for local testing..."

# Create SQLite cache database configuration
echo "📝 Creating SQLite cache configuration..."

# Update database.yml for SQLite cache testing
cat > config/database_cache_test.yml << 'EOF'
# Temporary SQLite configuration for Solid Cache testing
# This file demonstrates Solid Cache without requiring PostgreSQL

development:
  primary: &primary_development
    adapter: postgresql
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 25 } %>
    timeout: 5000
    database: ccq_development
  cache:
    adapter: sqlite3
    database: db/cache_development.sqlite3
    pool: 5
    timeout: 5000
    migrations_paths:
      - db/cache_migrate

test:
  primary: &primary_test
    adapter: postgresql
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 25 } %>
    timeout: 5000
    database: ccq_test<%= ENV['TEST_ENV_NUMBER'] %>
  cache:
    adapter: sqlite3
    database: db/cache_test.sqlite3
    pool: 5
    timeout: 5000
    migrations_paths:
      - db/cache_migrate
EOF

echo "💾 Backup original database.yml..."
cp config/database.yml config/database.yml.backup

echo "🔄 Using SQLite cache configuration..."
cp config/database_cache_test.yml config/database.yml

# Run the cache migrations
echo "🚀 Running cache migrations..."
bundle exec rails db:migrate:cache

# Enable development caching
echo "⚡ Enabling development caching..."
bundle exec rails dev:cache

# Test the cache functionality
echo "🧪 Testing cache functionality..."
bundle exec rails runner "
puts '=== Solid Cache SQLite Test ==='
puts 'Cache store: ' + Rails.cache.class.name
puts 'Writing test data...'
Rails.cache.write('solid_cache_test', 'Hello from Solid Cache + SQLite!')
result = Rails.cache.read('solid_cache_test')
puts 'Read result: ' + result.to_s
puts 'Test successful: ' + (result == 'Hello from Solid Cache + SQLite!').to_s
puts 'Cache database: ' + Rails.configuration.database_configuration['development']['cache']['database']
puts '=== End Test ==='
"

echo "✅ Solid Cache SQLite setup complete!"
echo ""
echo "📝 To verify cache is working:"
echo "   bundle exec rails console"
echo "   Rails.cache.write('test', 'data')"
echo "   Rails.cache.read('test')"
echo ""
echo "🔍 Check cache entries in SQLite:"
echo "   sqlite3 db/cache_development.sqlite3"
echo "   .tables"
echo "   SELECT * FROM solid_cache_entries;"
echo ""
echo "🔄 To restore original configuration:"
echo "   mv config/database.yml.backup config/database.yml"
