class CaseDetailsSection
  class << self
    def all_steps
      %i[level_of_help matter_type asylum_support]
    end

    def steps_for(session_data)
      steps(session_data).map { [_1] }
    end

    def steps(session_data)
      [:level_of_help, :matter_type, asylum_support(session_data)].compact
    end

    def asylum_support(session_data)
      :asylum_support if StepsLogic.upper_tribunal?(session_data)
    end
  end
end
