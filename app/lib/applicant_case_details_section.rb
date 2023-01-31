class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[level_of_help applicant dependant_details]
    end

    def steps_for(estimate)
      steps(estimate).map { [_1] }
    end

    def steps(estimate)
      [level_of_help, :applicant, dependant_details(estimate)].compact
    end

    def level_of_help
      :level_of_help if FeatureFlags.enabled?(:controlled)
    end

    def dependant_details(estimate)
      :dependant_details unless estimate.passporting
    end
  end
end
