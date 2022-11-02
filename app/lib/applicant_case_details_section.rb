class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[case_details applicant dependants dependant_details]
    end

    def steps_for(estimate)
      [
        [:case_details],
        [:applicant],
        [
          :dependants,
          (:dependant_details if estimate.dependants),
        ].compact,
      ]
    end
  end
end
