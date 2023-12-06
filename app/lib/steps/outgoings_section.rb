module Steps
  class OutgoingsSection
    class << self
      def all_steps
        %i[outgoings partner_outgoings property mortgage_or_loan_payment housing_costs]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.skip_income_questions?(session_data)
          []
        else
          [
            Steps::Group.new(:outgoings),
            (Steps::Group.new(:partner_outgoings) if Steps::Logic.partner?(session_data)),
            (Steps::Group.new(:property) if FeatureFlags.enabled?(:outgoings_flow, session_data)),
            (housing_costs_group if FeatureFlags.enabled?(:outgoings_flow, session_data)),
          ].compact
        end
      end

      def housing_costs_group(session_data)
        step = if Steps::Logic.owns_property_with_mortgage_or_loan?(session_data)
                 :mortgage_or_loan_payment
               elsif !Steps::Logic.owns_property_outright?(session_data)
                 :housing_costs
               end
        Steps::Group.new(step) if step
      end
    end
  end
end
