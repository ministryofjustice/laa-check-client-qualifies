class ApplicantDetailsSection
  class << self
    def all_steps
      %i[applicant]
    end

    def steps_for(estimate)
      if estimate.asylum_support_and_upper_tribunal?
        []
      else
        [[:applicant]]
      end
    end
  end
end
