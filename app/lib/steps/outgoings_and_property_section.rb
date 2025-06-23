module Steps
  class OutgoingsAndPropertySection
    class << self
      def all_steps
        %i[outgoings partner_outgoings property property_landlord property_entry shared_ownership_housing_costs mortgage_or_loan_payment housing_costs]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.skip_income_questions?(session_data)
          if Steps::Logic.skip_capital_questions?(session_data)
            []
          else
            [
              property_group(session_data),
            ].compact
          end
        else
          [
            Steps::Group.new(:outgoings),
            (Steps::Group.new(:partner_outgoings) if Steps::Logic.partner?(session_data)),
            means_tested_property_group(session_data),
          ].compact
        end
      end

      def property_steps(session_data)
        property_steps = %i[property]
        property_steps << :property_landlord if Steps::Logic.owns_property_shared_ownership?(session_data)
        property_steps
      end

      def property_group(session_data)
        property_steps = property_steps(session_data)
        property_steps << :property_entry if Steps::Logic.owns_property?(session_data)
        Steps::Group.new(*property_steps)
      end

      def means_tested_property_group(session_data)
        means_tested_property_steps = property_steps(session_data)
        housing_costs_step = housing_costs_step(session_data)
        means_tested_property_steps << housing_costs_step
        means_tested_property_steps << :property_entry if Steps::Logic.owns_property?(session_data)
        Steps::Group.new(*means_tested_property_steps.compact)
      end

      def housing_costs_step(session_data)
        if session_data["property_owned"] == "shared_ownership"
          :shared_ownership_housing_costs
        elsif Steps::Logic.owns_property_with_mortgage_or_loan?(session_data)
          :mortgage_or_loan_payment
        elsif !Steps::Logic.owns_property_outright?(session_data)
          :housing_costs
        end
      end
    end
  end
end
