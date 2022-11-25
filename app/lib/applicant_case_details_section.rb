class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[applicant dependant_details]
    end

    def steps_for(estimate)
      steps = if estimate.passporting
                [:applicant]
              else
                %i[applicant dependant_details]
              end
      steps.map { [_1] }
    end
  end
end
