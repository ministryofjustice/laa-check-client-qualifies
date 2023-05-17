module Steps
  class HousingCostsSection
    class << self
      def all_steps
        %i[housing_costs housing_exit]
      end

      def grouped_steps_for(session_data)
        return [] unless FeatureFlags.enabled?(:household_section)

        if Steps::Logic.passported?(session_data) || Steps::Logic.asylum_supported?(session_data)
          []
        else
          [Steps::Group.new(:housing_costs, :housing_exit)].compact
        end
      end

      def with_a_mortgage_or_loan
        # session_data["property_mortgage"]
      end

      def owned_outright
        # Steps::Logic.owns_property?(session_data) ? PROPERTY_STEPS : %i[property]
      end

      def does_not_own_home
        # :housing_costs unless Steps::Logic.owns_property?(session_data)
      end
    end
  end
end
