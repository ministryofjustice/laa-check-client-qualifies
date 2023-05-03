module Steps
  class CaseDetailsSection
    class << self
      def all_steps
        %i[level_of_help matter_type asylum_support]
      end

      def grouped_steps_for(session_data)
        groups(session_data).map { Steps::Group.new(_1) }
      end

      def groups(session_data)
        [:level_of_help, :matter_type, asylum_support(session_data)].compact
      end

      def asylum_support(session_data)
        :asylum_support if Steps::Logic.upper_tribunal?(session_data)
      end
    end
  end
end
