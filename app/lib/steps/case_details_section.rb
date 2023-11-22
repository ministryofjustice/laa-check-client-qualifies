module Steps
  class CaseDetailsSection
    class << self
      def all_steps
        under_18_steps = %i[under_18_clr aggregated_means regular_income under_eighteen_assets]
        case_type_steps = %i[domestic_abuse_applicant immigration_or_asylum immigration_or_asylum_type immigration_or_asylum_type_upper_tribunal asylum_support]
        %i[client_age level_of_help] + under_18_steps + case_type_steps
      end

      def grouped_steps_for(session_data)
        initial_steps(session_data) + post_level_of_help_steps(session_data)
      end

    private

      def initial_steps(session_data)
        if FeatureFlags.enabled?(:under_eighteen, session_data)
          [Steps::Group.new(:client_age), Steps::Group.new(:level_of_help)]
        else
          [Steps::Group.new(:level_of_help)]
        end
      end

      def post_level_of_help_steps(session_data)
        if Steps::Logic.controlled?(session_data)
          [Steps::Group.new(*under_eighteen_steps(session_data)),
           controlled_matter_type_group(session_data)].compact
        elsif Steps::Logic.under_eighteen_no_means_test_required?(session_data)
          []
        else
          [Steps::Group.new(:domestic_abuse_applicant),
           upper_tribunal_type_group(session_data)].compact
        end
      end

      def controlled_matter_type_group(session_data)
        return if Steps::Logic.under_eighteen_no_means_test_required?(session_data)

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

      def under_eighteen_steps(session_data)
        return [] unless Steps::Logic.client_under_eighteen?(session_data)

        is_clr = Steps::Logic.controlled_clr?(session_data)
        is_aggregated = Steps::Logic.aggregated_means?(session_data)
        is_regular_income = Steps::Logic.under_eighteen_regular_income?(session_data)
        [:under_18_clr,
         (:aggregated_means unless is_clr),
         (:regular_income unless is_clr || is_aggregated),
         (:under_eighteen_assets unless is_clr || is_aggregated || is_regular_income)].compact
      end
    end
  end
end
