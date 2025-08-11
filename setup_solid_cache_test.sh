#!/bin/bash

# Solid Cache Local Testing Setup Script
# Run this from the CCQ project root directory

echo "🔧 Setting up Solid Cache for local testing..."

# Add PostgreSQL to PATH for this session
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL not found!"
    echo ""
    echo "🍺 Install PostgreSQL with Homebrew:"
    echo "   brew install postgresql@15"
    echo "   brew services start postgresql@15"
    echo ""
    echo "🐳 Or use Docker:"
    echo "   docker run --name postgres-cache-test -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres:15"
    exit 1
fi

# Check if PostgreSQL is running
if ! /opt/homebrew/opt/postgresql@15/bin/pg_isready &> /dev/null; then
    echo "❌ PostgreSQL is not running!"
    echo "🚀 Start PostgreSQL:"
    echo "   brew services start postgresql@15"
    exit 1
fi

echo "✅ PostgreSQL is running"

# 1. Create the cache databases
echo "📊 Creating cache databases..."
/opt/homebrew/opt/postgresql@15/bin/createdb ccq_development_cache 2>/dev/null || echo "   (ccq_development_cache already exists)"
/opt/homebrew/opt/postgresql@15/bin/createdb ccq_test_cache 2>/dev/null || echo "   (ccq_test_cache already exists)"

# 2. Run the cache migrations
echo "🚀 Running cache migrations..."
bundle exec rails db:migrate:cache

# 3. Enable development caching
echo "⚡ Enabling development caching..."
bundle exec rails dev:cache

# 4. Test the cache functionality
echo "🧪 Testing cache functionality..."
bundle exec rails runner "
puts '=== Solid Cache Test ==='
puts 'Cache store: ' + Rails.cache.class.name
puts 'Writing test data...'
Rails.cache.write('solid_cache_test', 'Hello from Solid Cache!')
result = Rails.cache.read('solid_cache_test')
puts 'Read result: ' + result.to_s
puts 'Test successful: ' + (result == 'Hello from Solid Cache!').to_s
puts '=== End Test ==='
"

echo "✅ Solid Cache setup complete!"
echo ""
echo "📝 To verify cache is working:"
echo "   bundle exec rails console"
echo "   Rails.cache.write('test', 'data')"
echo "   Rails.cache.read('test')"
echo ""
echo "🔍 Check cache entries in database:"
echo "   bundle exec rails db -d cache"
echo "   SELECT * FROM solid_cache_entries;"
