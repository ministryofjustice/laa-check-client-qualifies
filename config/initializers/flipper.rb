require "flipper/adapters/pstore"

Flipper.configure do |config|
  config.adapter { Flipper::Adapters::PStore.new }
end

FEATURE_FLAGS = %i[partner].freeze

FEATURE_FLAGS.each do |flag|
  if ENV["#{flag.to_s.upcase}_FEATURE_FLAG"]&.casecmp("enabled")&.zero?
    Flipper.enable(flag)
  else
    Flipper.disable(flag)
  end
end
