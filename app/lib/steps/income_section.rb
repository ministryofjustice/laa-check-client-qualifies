module Steps
  class IncomeSection
    class << self
      def all_steps
        %i[employment_status income benefits benefit_details other_income]
      end

      def grouped_steps_for(session_data)
        logic = Steps::Logic::Thing.new(session_data)
        if logic.skip_income_questions?
          []
        else
          [Steps::Group.new(:employment_status),
           employment_steps(logic),
           benefit_steps(logic),
           Steps::Group.new(:other_income)].compact
        end
      end

    private

      def employment_steps(logic)
        Steps::Group.new(:income) if logic.employed?
      end

      def benefit_steps(logic)
        Steps::Group.new(*(logic.benefits? ? %i[benefits benefit_details] : %i[benefits]))
      end
    end
  end
end
