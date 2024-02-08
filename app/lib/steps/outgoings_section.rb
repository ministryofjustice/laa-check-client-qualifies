module Steps
  class OutgoingsSection
    class << self
      def all_steps
        %i[outgoings partner_outgoings property mortgage_or_loan_payment housing_costs]
      end

      def grouped_steps_for(session_data)
        logic = Steps::Logic::Thing.new(session_data)

        if logic.skip_income_questions?
          if FeatureFlags.enabled?(:outgoings_flow, session_data) && !logic.skip_capital_questions?
            [Steps::Group.new(:property)]
          else
            []
          end
        else
          [
            Steps::Group.new(:outgoings),
            (Steps::Group.new(:partner_outgoings) if logic.partner?),
            (Steps::Group.new(:property) if FeatureFlags.enabled?(:outgoings_flow, session_data)),
            (housing_costs_group(logic) if FeatureFlags.enabled?(:outgoings_flow, session_data)),
          ].compact
        end
      end

      def housing_costs_group(logic)
        step = if logic.owns_property_with_mortgage_or_loan?
                 :mortgage_or_loan_payment
               elsif !logic.owns_property_outright?
                 :housing_costs
               end
        Steps::Group.new(step) if step
      end
    end
  end
end
