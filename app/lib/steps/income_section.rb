module Steps
  class IncomeSection
    class << self
      def all_steps
        %i[employment_status employment income benefits benefit_details other_income]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.passported?(session_data) || Steps::Logic.asylum_supported?(session_data)
          []
        else
          [employment_status_step,
           employment_steps(session_data),
           benefit_steps(session_data),
           Steps::Group.new(:other_income)].compact
        end
      end

    private

      def employment_steps(session_data)
        key = FeatureFlags.enabled?(:self_employed) ? :income : :employment
        Steps::Group.new(key) if Steps::Logic.employed?(session_data)
      end

      def employment_status_step
        return unless FeatureFlags.enabled?(:self_employed)

        Steps::Group.new(:employment_status)
      end

      def benefit_steps(session_data)
        Steps::Group.new(*(Steps::Logic.benefits?(session_data) ? %i[benefits benefit_details] : %i[benefits]))
      end
    end
  end
end
