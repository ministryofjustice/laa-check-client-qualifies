module Steps
  class PostGrossIncomeEarlyEligibilitySection
    class << self
      def all_steps
        %i[gross_income_early_eligibility]
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.show_income_sections?(session_data)
          []
        else
          [early_eligibility_step(session_data)].compact
        end
      end

      def early_eligibility_step(session_data)
        Steps::Group.new(:gross_income_early_eligibility) if Steps::Logic.ineligible_gross_income?(session_data)
      end
    end
  end
end
