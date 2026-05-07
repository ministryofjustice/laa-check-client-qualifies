class ModeConfig
  MODES = %w[standalone embedded].freeze

  DEFAULTS = {
    "standalone" => {
      database_enabled: true,
      admin_enabled: true,
      oauth_enabled: true,
      analytics_enabled: true,
      document_generation_enabled: true,
      authenticated_flow_enabled: false,
    },
    "embedded" => {
      database_enabled: false,
      admin_enabled: false,
      oauth_enabled: false,
      analytics_enabled: false,
      document_generation_enabled: false,
      authenticated_flow_enabled: true,
    },
  }.freeze

  def self.mode
    # Using memoization for mode can cause weird behaviour with
    # dotenv based on load order in application.rb
    raw = ENV.fetch("CCQ_MODE", "standalone")
    raise ArgumentError, "Unknown CCQ_MODE: #{raw}" unless MODES.include?(raw)

    raw
  end

  def self.embedded?   = mode == "embedded"
  def self.standalone? = mode == "standalone"

  def self.cache_store
    return :solid_cache_store if standalone?

    [
      :redis_cache_store,
      Rails.application.config_for(:redis).symbolize_keys,
    ]
  end

  DEFAULTS["standalone"].each_key do |capability|
    define_singleton_method("#{capability}?") { DEFAULTS.dig(mode, capability) }
  end
end
