class CaseDetailsSection
  class << self
    def all_steps
      %i[level_of_help matter_type asylum_support]
    end

    def steps_for(estimate)
      steps(estimate).map { [_1] }
    end

    def steps(estimate)
      [level_of_help, matter_type(estimate), asylum_support(estimate)].compact
    end

    def level_of_help
      :level_of_help if FeatureFlags.enabled?(:controlled)
    end

    def matter_type(estimate)
      :matter_type if estimate.controlled? && FeatureFlags.enabled?(:asylum_and_immigration)
    end

    def asylum_support(estimate)
      :asylum_support if estimate.level_of_help == "controlled" && estimate.upper_tribunal?
    end
  end
end
