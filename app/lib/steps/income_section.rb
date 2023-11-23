module Steps
  class IncomeSection
    class << self
      def all_steps
        %i[employment_status income benefits benefit_details other_income]
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.show_income_sections?(session_data)
          []
        else
          [Steps::Group.new(:employment_status),
           employment_steps(session_data),
           benefit_steps(session_data),
           Steps::Group.new(:other_income)].compact
        end
      end

    private

      def employment_steps(session_data)
        Steps::Group.new(:income) if Steps::Logic.employed?(session_data)
      end

      def benefit_steps(session_data)
        Steps::Group.new(*(Steps::Logic.benefits?(session_data) ? %i[benefits benefit_details] : %i[benefits]))
      end
    end
  end
end
