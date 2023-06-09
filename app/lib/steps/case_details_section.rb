module Steps
  class CaseDetailsSection
    class << self
      def all_steps
        %i[level_of_help matter_type immigration_or_asylum immigration_or_asylum_type asylum_support]
      end

      def grouped_steps_for(session_data)
        groups(session_data).map { Steps::Group.new(*_1) }
      end

      def groups(session_data)
        [%i[level_of_help], matter_type_group(session_data)].compact
      end

      def matter_type_group(session_data)
        if Steps::Logic.controlled?(session_data)
          controlled_matter_type_group(session_data)
        else
          certificated_matter_type_group(session_data)
        end
      end

      def certificated_matter_type_group(session_data)
        Steps::Logic.upper_tribunal?(session_data) ? %i[matter_type asylum_support] : %i[matter_type]
      end

      def controlled_matter_type_group(session_data)
        Steps::Logic.upper_tribunal?(session_data) ? %i[immigration_or_asylum immigration_or_asylum_type asylum_support] : %i[immigration_or_asylum]
      end
    end
  end
end
