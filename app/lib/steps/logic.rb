module Steps
  class Logic
    # The methods in this helper need to consider not just whether a given attribute is set, but also whether
    # or not other elements of the session render the form invalid. While in most cases we rely on the Check
    # model to do this thinking for us, Check relies on Steps::Helper which in turn relies on Steps::Logic
    class << self
      def client_under_eighteen?(session_data)
        session_data["client_age"]&.==(ClientAgeForm::UNDER_18)
      end

      def controlled?(session_data)
        session_data["level_of_help"] == LevelOfHelpForm::LEVELS_OF_HELP[:controlled]
      end

      def controlled_clr?(session_data)
        client_under_eighteen?(session_data) && controlled?(session_data) && session_data["controlled_legal_representation"]
      end

      def aggregated_means?(session_data)
        client_under_eighteen?(session_data) && session_data["aggregated_means"]
      end

      def under_eighteen_regular_income?(session_data)
        client_under_eighteen?(session_data) && !aggregated_means?(session_data) && session_data["regular_income"]
      end

      def under_eighteen_assets?(session_data)
        client_under_eighteen?(session_data) && !aggregated_means?(session_data) && !under_eighteen_regular_income?(session_data) && session_data["under_eighteen_assets"]
      end

      def under_eighteen_no_means_test_required?(session_data)
        return false unless client_under_eighteen?(session_data)
        return true unless controlled?(session_data)
        return true if controlled_clr?(session_data)

        aggregated_means?(session_data) == false && under_eighteen_regular_income?(session_data) == false && under_eighteen_assets?(session_data) == false
      end

      def immigration_or_asylum?(session_data)
        if controlled?(session_data)
          session_data["immigration_or_asylum"]
        else
          session_data["immigration_or_asylum_type_upper_tribunal"].in?(%w[immigration_upper asylum_upper]) && !domestic_abuse_applicant?(session_data)
        end
      end

      def domestic_abuse_applicant?(session_data)
        session_data["domestic_abuse_applicant"] && !controlled?(session_data)
      end

      def asylum_supported?(session_data)
        immigration_or_asylum?(session_data) && session_data["asylum_support"]
      end

      def skip_client_questions?(session_data)
        under_eighteen_no_means_test_required?(session_data) || asylum_supported?(session_data)
      end

      def passported?(session_data)
        !skip_client_questions?(session_data) && session_data["passporting"]
      end

      def skip_income_questions?(session_data)
        skip_client_questions?(session_data) || passported?(session_data)
      end

      def skip_capital_questions?(session_data)
        skip_client_questions?(session_data)
      end

      def owns_property?(session_data)
        !skip_capital_questions?(session_data) && session_data["property_owned"]&.in?(PropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def owns_property_outright?(session_data)
        !skip_capital_questions?(session_data) && session_data["property_owned"] == "outright"
      end

      def owns_property_with_mortgage_or_loan?(session_data)
        !skip_capital_questions?(session_data) && session_data["property_owned"] == "with_mortgage"
      end

      def owns_additional_property?(session_data)
        !skip_capital_questions?(session_data) && session_data["additional_property_owned"]&.in?(AdditionalPropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def owns_vehicle?(session_data)
        !skip_capital_questions?(session_data) && session_data["vehicle_owned"]
      end

      def employed?(session_data)
        return false if skip_income_questions?(session_data)

        EmploymentStatusForm::EMPLOYED_STATUSES.map(&:to_s).include? session_data["employment_status"]
      end

      def benefits?(session_data)
        return false if skip_income_questions?(session_data)

        session_data["receives_benefits"]
      end

      def partner?(session_data)
        !skip_client_questions?(session_data) && session_data["partner"]
      end

      def partner_owns_additional_property?(session_data)
        return false unless partner?(session_data)

        session_data["partner_additional_property_owned"]&.in?(PropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def partner_employed?(session_data)
        return false if skip_income_questions?(session_data) || !partner?(session_data)

        EmploymentStatusForm::EMPLOYED_STATUSES.map(&:to_s).include? session_data["partner_employment_status"]
      end

      def partner_benefits?(session_data)
        return false if skip_income_questions?(session_data) || !partner?(session_data)

        session_data["partner_receives_benefits"]
      end

      def dependants?(session_data)
        return false if skip_income_questions?(session_data)

        session_data["child_dependants"] || session_data["adult_dependants"]
      end

      def dependants_get_income?(session_data)
        return false if skip_income_questions?(session_data) || !dependants?(session_data)

        session_data["dependants_get_income"]
      end
    end
  end
end
