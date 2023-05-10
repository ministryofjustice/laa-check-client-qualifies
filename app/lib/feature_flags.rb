class FeatureFlags
  ENABLED_AFTER_DATE = {
    example_2125_flag: { from: "2125-01-01", public: false },
  }.freeze

  STATIC_FLAGS = %i[sentry cw_forms household_section special_applicant_groups].freeze

  class << self
    def enabled?(flag)
      if ENABLED_AFTER_DATE.key?(flag)
        Time.current.beginning_of_day >= ENABLED_AFTER_DATE.dig(flag, :from)
      elsif STATIC_FLAGS.include?(flag)
        ENV["#{flag.to_s.upcase}_FEATURE_FLAG"]&.casecmp("enabled")&.zero?
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
  end
end
