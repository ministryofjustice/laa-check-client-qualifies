class ApplicantDetailsSection
  class << self
    def all_steps
      %i[applicant dependant_details]
    end

    def steps_for(estimate)
      if estimate.asylum_support
        []
      else
        steps(estimate).map { [_1] }
      end
    end

    def steps(estimate)
      [:applicant, dependant_details(estimate)].compact
    end

    def dependant_details(estimate)
      :dependant_details unless estimate.passporting
    end
  end
end
