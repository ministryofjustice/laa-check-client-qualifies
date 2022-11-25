class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[applicant dependant_details]
    end

    def steps_for(estimate)
      steps = [
        [:applicant],
      ].compact

      unless estimate.passporting
        steps <<
          [
            (:dependant_details if estimate.dependants),
          ].compact
      end
      steps
    end
  end
end
