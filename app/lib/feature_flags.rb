class FeatureFlags
  ENABLED_AFTER_DATE = {
    example_2125_flag: { from: "2125-01-01", public: false },
  }.freeze

  STATIC_FLAGS = %i[sentry cw_forms special_applicant_groups self_employed].freeze

  class << self
    def enabled?(flag)
      if overrideable?
        override = FeatureFlagOverride.find_by(key: flag)
        if override
          return override.value
        end
      end

      if ENABLED_AFTER_DATE.key?(flag)
        Time.current.beginning_of_day >= ENABLED_AFTER_DATE.dig(flag, :from)
      elsif STATIC_FLAGS.include?(flag)
        ENV["#{flag.to_s.upcase}_FEATURE_FLAG"]&.casecmp("enabled")&.zero? || false
      else
        raise "Unrecognised flag '#{flag}'"
      end
    end

    def time_dependant
      ENABLED_AFTER_DATE.select { |_, properties| properties[:public] }.map { |flag, _| flag }
    end

    def static
      STATIC_FLAGS
    end

    def overrideable?
      ENV["FEATURE_FLAG_OVERRIDES"]&.casecmp("enabled")&.zero?
    end
  end
end
