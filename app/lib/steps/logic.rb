module Steps
  class Logic
    # The methods in this helper need to consider not just whether a given attribute is set, but also whether
    # or not other elements of the session render the form invalid. While in most cases we rely on the Check
    # model to do this thinking for us, Check relies on Steps::Helper which in turn relies on Steps::Logic
    class << self
      def controlled?(session_data)
        session_data["level_of_help"] == LevelOfHelpForm::LEVELS_OF_HELP[:controlled]
      end

      def upper_tribunal?(session_data)
        if controlled?(session_data)
          session_data["immigration_or_asylum"]
        else
          session_data["matter_type"].in?(%w[immigration asylum])
        end
      end

      def asylum_supported?(session_data)
        upper_tribunal?(session_data) && session_data["asylum_support"]
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
        return false if asylum_supported?(session_data) || passported?(session_data)

        employment_statuses = FeatureFlags.enabled?(:self_employed, session_data) ? EmploymentStatusForm::EMPLOYED_STATUSES : ApplicantForm::EMPLOYED_STATUSES

        employment_statuses.map(&:to_s).include? session_data["employment_status"]
      end

      def benefits?(session_data)
        return false if asylum_supported?(session_data) || passported?(session_data)

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

        employment_statuses = FeatureFlags.enabled?(:self_employed, session_data) ? EmploymentStatusForm::EMPLOYED_STATUSES : ApplicantForm::EMPLOYED_STATUSES

        employment_statuses.map(&:to_s).include? session_data["partner_employment_status"]
      end

      def partner_benefits?(session_data)
        return false if passported?(session_data) || !partner?(session_data)

        session_data["partner_receives_benefits"]
      end
    end
  end
end
