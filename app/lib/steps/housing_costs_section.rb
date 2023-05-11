module Steps
  class HousingCostsSection
    class << self
      def all_steps
        %i[housing_costs]
      end

      def grouped_steps_for(session_data)
        return [] unless FeatureFlags.enabled?(:household_section)

        if Steps::Logic.passported?(session_data) || Steps::Logic.asylum_supported?(session_data)
          []
        else
          [Steps::Group.new(:housing_costs)].compact
        end
      end
    end
  end
end
