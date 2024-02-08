module Steps
  class ApplicantDetailsSection
    class << self
      def all_steps
        %i[applicant dependant_details dependant_income dependant_income_details]
      end

      def grouped_steps_for(session_data)
        logic = Steps::Logic::Thing.new(session_data)
        if logic.skip_client_questions?
          []
        else
          groups(logic).map { Steps::Group.new(*_1) }
        end
      end

      def groups(logic)
        [[:applicant], dependant_details(logic)].compact
      end

      def dependant_details(logic)
        return if logic.passported?

        [:dependant_details, dependant_income(logic)].flatten.compact
      end

      def dependant_income(logic)
        return unless logic.dependants?

        [:dependant_income, dependant_income_details(logic)]
      end

      def dependant_income_details(logic)
        :dependant_income_details if logic.dependants_get_income?
      end
    end
  end
end
