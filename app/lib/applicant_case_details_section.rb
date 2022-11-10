class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[case_details partner applicant dependants dependant_details]
    end

    def steps_for(estimate)
      steps = [
        [:case_details],
        [:partner],
        [:applicant],
      ]
      unless estimate.passporting
        steps <<
          [
            :dependants,
            (:dependant_details if estimate.dependants),
          ].compact
      end
      steps
    end
  end
end
