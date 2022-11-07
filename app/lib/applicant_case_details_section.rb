class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[case_details applicant dependants dependant_details]
    end

    def steps_for(estimate)
      steps = [
        [:case_details],
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
