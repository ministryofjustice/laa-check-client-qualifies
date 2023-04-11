class ApplicantDetailsSection
  class << self
    def all_steps
      %i[applicant dependant_details]
    end

    def steps_for(session_data)
      if StepsLogic.asylum_supported?(session_data)
        []
      else
        steps(session_data).map { [_1] }
      end
    end

    def steps(session_data)
      [:applicant, dependant_details(session_data)].compact
    end

    def dependant_details(session_data)
      :dependant_details unless StepsLogic.passported?(session_data)
    end
  end
end
