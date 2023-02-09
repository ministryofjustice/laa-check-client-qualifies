class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[level_of_help tribunal matter_type applicant dependant_details]
    end

    def steps_for(estimate)
      steps(estimate).map { [_1] }
    end

    def steps(estimate)
      [level_of_help, tribunal(estimate), matter_type(estimate), :applicant, dependant_details(estimate)].compact
    end

    def level_of_help
      :level_of_help if FeatureFlags.enabled?(:controlled)
    end

    def tribunal(estimate)
      :tribunal if estimate.level_of_help == "controlled" && FeatureFlags.enabled?(:asylum_and_immigration)
    end

    def matter_type(estimate)
      :matter_type if estimate.upper_tribunal
    end

    def dependant_details(estimate)
      :dependant_details unless estimate.passporting
    end
  end
end
