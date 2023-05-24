module Steps
  class IncomeSection
    class << self
      def all_steps
        %i[employment housing_benefit housing_benefit_details benefits benefit_details other_income outgoings]
      end

      def all_steps_for_current_feature_flags
        if FeatureFlags.enabled?(:household_section)
          %i[employment benefits benefit_details other_income].freeze
        else
          all_steps
        end
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.passported?(session_data) || Steps::Logic.asylum_supported?(session_data)
          []
        elsif FeatureFlags.enabled?(:household_section)
          [employment_steps(session_data),
           benefit_steps(session_data),
           Steps::Group.new(:other_income)].compact
        else
          [employment_steps(session_data),
           housing_benefit_steps(session_data),
           benefit_steps(session_data),
           Steps::Group.new(:other_income),
           Steps::Group.new(:outgoings)].compact
        end
      end

    private

      def employment_steps(session_data)
        Steps::Group.new(:employment) if Steps::Logic.employed?(session_data)
      end

      def housing_benefit_steps(session_data)
        return if FeatureFlags.enabled?(:household_section)

        Steps::Group.new(*(Steps::Logic.housing_benefit?(session_data) ? %i[housing_benefit housing_benefit_details] : %i[housing_benefit]))
      end

      def benefit_steps(session_data)
        Steps::Group.new(*(Steps::Logic.benefits?(session_data) ? %i[benefits benefit_details] : %i[benefits]))
      end
    end
  end
end
