class CaseDetailsSection
  class << self
    def all_steps
      %i[level_of_help matter_type asylum_support]
    end

    def steps_for(estimate)
      steps(estimate).map { [_1] }
    end

    def steps(estimate)
      [:level_of_help, matter_type, asylum_support(estimate)].compact
    end

    def matter_type
      :matter_type if FeatureFlags.enabled?(:asylum_and_immigration)
    end

    def asylum_support(estimate)
      :asylum_support if estimate.upper_tribunal?
    end
  end
end
