class ApplicantCaseDetailsSection
  class << self
    def all_steps
      %i[case_details applicant]
    end

    def step_should_save?(_model, _step)
      true
    end

    def steps_for(_estimate)
      all_steps.map { |step| [step] }
    end
  end
end
