class FeatureFlags
  ENABLED_AFTER_DATE = {
    example_2125_flag: { from: "2125-01-01", public: false },
  }.freeze

  # the values of some feature flags will come from the session and not the env variables.
  # "global" - feature flag value should be derived from the env variable
  # "session" - feature flag value should be derived from the session_data of the check
  STATIC_FLAGS = {
    example: "session",
    sentry: "global",
    public_beta: "global",
    index_production: "global",
    maintenance_mode: "global",
    basic_authentication: "global",
  }.freeze

  class << self
    def enabled?(flag, session_data = nil, without_session_data: false)
      if session_data.nil? && !without_session_data
        raise "Pass in session_data or set without_session_data to true"
      end

      if session_data && session_data["feature_flags"]&.key?(flag.to_s)
        return session_data["feature_flags"][flag.to_s]
      end

      if overrideable?
        override = FeatureFlagOverride.find_by(key: flag)
        if override
          return override.value
        end
      end

      if STATIC_FLAGS.key?(flag)
        ENV["#{flag.to_s.upcase}_FEATURE_FLAG"]&.casecmp("enabled")&.zero? || false
      elsif ENABLED_AFTER_DATE.key?(flag)
        Time.current.beginning_of_day >= ENABLED_AFTER_DATE.dig(flag, :from)
      else
        raise "Unrecognised flag '#{flag}'"
      end
    end

    def time_dependant
      ENABLED_AFTER_DATE.select { |_, properties| properties[:public] }.map { |flag, _| flag }
    end

    def static
      STATIC_FLAGS.keys
    end

    def overrideable?
      ENV["FEATURE_FLAG_OVERRIDES"]&.casecmp("enabled")&.zero?
    end
  end
end
