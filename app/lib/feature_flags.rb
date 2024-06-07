class FeatureFlags
  # public: false is a marker that this is a test flag
  # all flags intended to go into production should have public: set to true
  ENABLED_AFTER_DATE = {
    example_2125_flag: { from: "2125-01-01", public: false },
    mtr_accelerated: { from: "2024-06-24", public: true },
  }.freeze

  # the values of some feature flags will come from the session and not the env variables.
  # "global" - feature flag value should be derived from the env variable
  # "session" - feature flag value should be derived from the session_data of the check
  # "default" - where a flag is not set this is the value the check or tests should fall back to
  STATIC_FLAGS = {
    # example and example2 are just here for tests and should not be used in code.
    example: { type: "session", default: false },
    example2: { type: "session", default: true },
    sentry: { type: "global", default: false },
    index_production: { type: "global", default: false },
    maintenance_mode: { type: "global", default: false },
    basic_authentication: { type: "global", default: false },
    early_eligibility: { type: "session", default: false },
    legacy_assets_no_reveal: { type: "session", default: true },
  }.freeze

  class << self
    def enabled?(flag, session_data = nil, without_session_data: false)
      if session_data.nil? && !without_session_data
        raise "Pass in session_data or set without_session_data to true"
      end

      #  if the flag exists in the session_data use that setting
      if session_data && session_data["feature_flags"]&.key?(flag.to_s)
        return session_data["feature_flags"][flag.to_s]
      end

      possible_override = overrideable_flag(flag)
      return possible_override unless possible_override.nil?

      if STATIC_FLAGS.key?(flag)
        # if the flag is a valid flag and of type `session` but does not
        # exist in the session_data we return the default value for that flag
        if STATIC_FLAGS[flag][:type] == "session"
          STATIC_FLAGS[flag][:default]
        else
          # if it is a global flag we check the env_var
          # if there is no env_var specified we use the default value for that flag
          env_var_flag_or_default(flag)
        end
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
      feature_flag_override = ENV["FEATURE_FLAG_OVERRIDES"]&.downcase

      if feature_flag_override.present?
        feature_flag_override == "enabled"
      end
    end

    def session_flags
      # this method sets the feature flags at the start of the check
      session_flag_keys = STATIC_FLAGS.select { |_, v| v.fetch(:type) == "session" }.keys

      hash = session_flag_keys.map do |flag|
        value = overrideable_flag(flag)
        value = env_var_flag_or_default(flag) if value.nil?

        [flag, value]
      end
      hash.to_h.stringify_keys
    end

  private

    def overrideable_flag(flag)
      if overrideable?
        override = FeatureFlagOverride.find_by(key: flag)
        if override
          override.value
        end
      end
    end

    def env_var_flag_or_default(flag)
      flag_value = ENV["#{flag.to_s.upcase}_FEATURE_FLAG"]&.downcase

      if flag_value.present?
        flag_value == "enabled"
      else
        STATIC_FLAGS.fetch(flag).fetch(:default)
      end
    end
  end
end
