require "flipper/adapters/pstore"
require_relative "../../app/lib/feature_flags"

Flipper.configure do |config|
  config.adapter { Flipper::Adapters::PStore.new }
end

FeatureFlags::FLIPPER_FLAGS.each do |flag|
  if ENV["#{flag.to_s.upcase}_FEATURE_FLAG"]&.casecmp("enabled")&.zero?
    Flipper.enable(flag)
  else
    Flipper.disable(flag)
  end
end
