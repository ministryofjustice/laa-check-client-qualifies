class FeatureFlags
  ENABLED_AFTER_DATE = {
    example_2125_flag: "2125-01-01",
    disregard_cost_of_living: "2023-01-10",
  }.freeze

  class << self
    def enabled?(flag)
      if ENABLED_AFTER_DATE.key?(flag)
        Time.current.beginning_of_day >= ENABLED_AFTER_DATE[flag]
      else
        Flipper.enabled?(flag)
      end
    end
  end
end
