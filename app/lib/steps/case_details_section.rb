module Steps
  class CaseDetailsSection
    class << self
      def all_steps
        under_18_steps = %i[under_18_clr aggregated_means how_to_aggregate regular_income under_eighteen_assets]
        case_type_steps = %i[domestic_abuse_applicant immigration_or_asylum immigration_or_asylum_type immigration_or_asylum_type_upper_tribunal asylum_support]
        %i[client_age level_of_help] + under_18_steps + case_type_steps
      end

      def grouped_steps_for(session_data)
        initial_steps + post_level_of_help_steps(Steps::Logic::Thing.new(session_data))
      end

    private

      def initial_steps
        [Steps::Group.new(:client_age), Steps::Group.new(:level_of_help)]
      end

      def post_level_of_help_steps(session_data)
        if session_data.controlled?
          [Steps::Group.new(*under_eighteen_steps(session_data)),
           controlled_matter_type_group(session_data)].compact
        elsif session_data.under_eighteen_no_means_test_required?
          []
        else
          [Steps::Group.new(:domestic_abuse_applicant),
           upper_tribunal_type_group(session_data)].compact
        end
      end

      def controlled_matter_type_group(session_data)
        return if session_data.under_eighteen_no_means_test_required?

        steps = session_data.immigration_or_asylum? ? %i[immigration_or_asylum immigration_or_asylum_type asylum_support] : %i[immigration_or_asylum]
        Steps::Group.new(*steps)
      end

      def upper_tribunal_type_group(session_data)
        steps = if session_data.domestic_abuse_applicant?
                  []
                elsif session_data.immigration_or_asylum?
                  %i[immigration_or_asylum_type_upper_tribunal asylum_support]
                else
                  %i[immigration_or_asylum_type_upper_tribunal]
                end

        Steps::Group.new(*steps)
      end

      def under_eighteen_steps(steps_logic)
        return [] unless steps_logic.client_under_eighteen?

        is_clr = steps_logic.controlled_clr?
        is_aggregated = steps_logic.aggregated_means?
        is_regular_income = steps_logic.under_eighteen_regular_income?
        [:under_18_clr,
         (:aggregated_means unless is_clr),
         (:how_to_aggregate if is_aggregated && !is_clr),
         (:regular_income unless is_clr || is_aggregated),
         (:under_eighteen_assets unless is_clr || is_aggregated || is_regular_income)].compact
      end
    end
  end
end
