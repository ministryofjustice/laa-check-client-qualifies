module Steps
  class CaseDetailsSection
    class << self
      def all_steps
        %i[level_of_help domestic_abuse_applicant immigration_or_asylum immigration_or_asylum_type immigration_or_asylum_type_upper_tribunal asylum_support]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.controlled?(session_data)
          [Steps::Group.new(:level_of_help),
           controlled_matter_type_group(session_data)].compact
        else
          [Steps::Group.new(:level_of_help),
           Steps::Group.new(:domestic_abuse_applicant),
           upper_tribunal_type_group(session_data)].compact
        end
      end

    private

      def controlled_matter_type_group(session_data)
        steps = Steps::Logic.immigration_or_asylum?(session_data) ? %i[immigration_or_asylum immigration_or_asylum_type asylum_support] : %i[immigration_or_asylum]
        Steps::Group.new(*steps)
      end

      def upper_tribunal_type_group(session_data)
        steps = if Steps::Logic.domestic_abuse_applicant?(session_data)
                  []
                elsif Steps::Logic.immigration_or_asylum?(session_data)
                  %i[immigration_or_asylum_type_upper_tribunal asylum_support]
                else
                  %i[immigration_or_asylum_type_upper_tribunal]
                end

        Steps::Group.new(*steps)
      end
    end
  end
end
