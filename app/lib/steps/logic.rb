module Steps
  class Logic
    # The methods in this helper need to consider not just whether a given attribute is set, but also whether
    # or not other elements of the session render the form invalid. While in most cases we rely on the Check
    # model to do this thinking for us, Check relies on Steps::Helper which in turn relies on Steps::Logic
    class << self
      def client_under_eighteen?(session_data)
        session_data["client_age"] == ClientAgeForm::UNDER_18
      end

      def controlled?(session_data)
        session_data["level_of_help"] == LevelOfHelpForm::LEVELS_OF_HELP[:controlled]
      end

      def aggregated_means?(session_data)
        client_under_eighteen?(session_data) && session_data["aggregated_means"]
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

      def passported?(session_data)
        !asylum_supported?(session_data) && session_data["passporting"]
      end

      def owns_property?(session_data)
        !asylum_supported?(session_data) && session_data["property_owned"]&.in?(PropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def owns_property_outright?(session_data)
        !asylum_supported?(session_data) && session_data["property_owned"] == "outright"
      end

      def owns_property_with_mortgage_or_loan?(session_data)
        !asylum_supported?(session_data) && session_data["property_owned"] == "with_mortgage"
      end

      def owns_additional_property?(session_data)
        !asylum_supported?(session_data) && session_data["additional_property_owned"]&.in?(AdditionalPropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def owns_vehicle?(session_data)
        !asylum_supported?(session_data) && session_data["vehicle_owned"]
      end

      def employed?(session_data)
        return false unless show_income_sections?(session_data)

        EmploymentStatusForm::EMPLOYED_STATUSES.map(&:to_s).include? session_data["employment_status"]
      end

      def benefits?(session_data)
        return false unless show_income_sections?(session_data)

        session_data["receives_benefits"]
      end

      def partner?(session_data)
        !asylum_supported?(session_data) && session_data["partner"]
      end

      def partner_owns_additional_property?(session_data)
        return false unless partner?(session_data)

        session_data["partner_additional_property_owned"]&.in?(PropertyForm::OWNED_OPTIONS.map(&:to_s))
      end

      def partner_employed?(session_data)
        return false if passported?(session_data) || !partner?(session_data)

        EmploymentStatusForm::EMPLOYED_STATUSES.map(&:to_s).include? session_data["partner_employment_status"]
      end

      def partner_benefits?(session_data)
        return false if passported?(session_data) || !partner?(session_data)

        session_data["partner_receives_benefits"]
      end

      def dependants?(session_data)
        return false if asylum_supported?(session_data) || passported?(session_data)

        session_data["child_dependants"] || session_data["adult_dependants"]
      end

      def dependants_get_income?(session_data)
        return false if asylum_supported?(session_data) || passported?(session_data) || !dependants?(session_data)

        session_data["dependants_get_income"]
      end

      def ineligible_gross_income?(session_data)
        return false unless show_income_sections?(session_data)

        return false unless session_data["api_result"]

        session_data.dig("api_result", "result_summary", "gross_income", "proceeding_types").first["result"] == "ineligible"
      end

      def ineligible_disposable_income?(session_data)
        return false unless show_outgoings_sections?(session_data)

        return false unless session_data["api_result"]

        session_data.dig("api_result", "result_summary", "disposable_income", "proceeding_types").first["result"] == "ineligible"
      end

      def show_income_sections?(session_data)
        return false if asylum_supported?(session_data) || passported?(session_data)

        true
      end

      def show_outgoings_sections?(session_data)
        return false if passported?(session_data) || asylum_supported?(session_data)

        return false if session_data["skip_to_check_answers"] && ineligible_gross_income?(session_data)

        true
      end

      def show_capital_sections?(session_data)
        return false if asylum_supported?(session_data)

        return false if session_data["skip_to_check_answers"] && ineligible_gross_income?(session_data)

        return false if session_data["skip_to_check_answers"] && ineligible_disposable_income?(session_data)

        true
      end
    end
  end
end
