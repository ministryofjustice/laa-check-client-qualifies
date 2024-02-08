module Steps
  module Logic
    # The methods in this helper need to consider not just whether a given attribute is set, but also whether
    # or not other elements of the session render the form invalid. While in most cases we rely on the Check
    # model to do this thinking for us, Check relies on Steps::Helper which in turn relies on Steps::Logic
    class Thing
      def initialize(session_data)
        @session_data = session_data
      end

      def client_under_eighteen?
        session_data["client_age"]&.==(ClientAgeForm::UNDER_18)
      end

      def controlled?
        session_data["level_of_help"] == LevelOfHelpForm::LEVELS_OF_HELP[:controlled]
      end

      def controlled_clr?
        client_under_eighteen? && controlled? && session_data["controlled_legal_representation"]
      end

      def aggregated_means?
        client_under_eighteen? && session_data["aggregated_means"]
      end

      def under_eighteen_regular_income?
        client_under_eighteen? && !aggregated_means? && session_data["regular_income"]
      end

      def under_eighteen_assets?
        client_under_eighteen? && !aggregated_means? && !under_eighteen_regular_income? && session_data["under_eighteen_assets"]
      end

      def under_eighteen_no_means_test_required?
        return false unless client_under_eighteen?
        return true unless controlled?
        return true if controlled_clr?

        not_aggregated_no_income_low_capital?
      end

      def not_aggregated_no_income_low_capital?
        aggregated_means? == false && under_eighteen_regular_income? == false && under_eighteen_assets? == false
      end

      def immigration_or_asylum?
        if controlled?
          session_data["immigration_or_asylum"]
        else
          session_data["immigration_or_asylum_type_upper_tribunal"].in?(%w[immigration_upper asylum_upper]) && !domestic_abuse_applicant?
        end
      end

      def domestic_abuse_applicant?
        session_data["domestic_abuse_applicant"] && !controlled?
      end

      def asylum_supported?
        immigration_or_asylum? && session_data["asylum_support"]
      end

      def skip_client_questions?
        under_eighteen_no_means_test_required? || asylum_supported?
      end

      def passported?
        !skip_client_questions? && session_data["passporting"]
      end

      def skip_income_questions?
        skip_client_questions? || passported?
      end

      def skip_capital_questions?
        skip_client_questions?
      end

      def owns_property?
        !skip_capital_questions? && session_data["property_owned"]&.in?(PropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def owns_property_outright?
        !skip_capital_questions? && session_data["property_owned"] == "outright"
      end

      def owns_property_with_mortgage_or_loan?
        !skip_capital_questions? && session_data["property_owned"] == "with_mortgage"
      end

      def owns_additional_property?
        !skip_capital_questions? && session_data["additional_property_owned"]&.in?(AdditionalPropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def owns_vehicle?
        !skip_capital_questions? && session_data["vehicle_owned"]
      end

      def employed?
        return false if skip_income_questions?

        EmploymentStatusForm::EMPLOYED_STATUSES.map(&:to_s).include? session_data["employment_status"]
      end

      def benefits?
        return false if skip_income_questions?

        session_data["receives_benefits"]
      end

      def partner?
        !skip_client_questions? && session_data["partner"]
      end

      def partner_owns_additional_property?
        return false unless partner?

        session_data["partner_additional_property_owned"]&.in?(PropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def partner_employed?
        return false if skip_income_questions? || !partner?

        EmploymentStatusForm::EMPLOYED_STATUSES.map(&:to_s).include? session_data["partner_employment_status"]
      end

      def partner_benefits?
        return false if skip_income_questions? || !partner?

        session_data["partner_receives_benefits"]
      end

      def dependants?
        return false if skip_income_questions?

        session_data["child_dependants"] || session_data["adult_dependants"]
      end

      def dependants_get_income?
        return false if skip_income_questions? || !dependants?

        session_data["dependants_get_income"]
      end

    private

      attr_reader :session_data
    end
  end
end
