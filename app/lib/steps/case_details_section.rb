module Steps
  class CaseDetailsSection
    class << self
      def all_steps
        %i[level_of_help matter_type asylum_support]
      end

      def all_steps_for_current_feature_flags
        all_steps
      end

      def grouped_steps_for(session_data)
        groups(session_data).map { Steps::Group.new(*_1) }
      end

      def groups(session_data)
        [%i[level_of_help], matter_type_group(session_data)].compact
      end

      def matter_type_group(session_data)
        Steps::Logic.upper_tribunal?(session_data) ? %i[matter_type asylum_support] : %i[matter_type]
      end
    end
  end
end
