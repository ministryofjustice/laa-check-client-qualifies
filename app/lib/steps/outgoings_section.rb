module Steps
  class OutgoingsSection
    class << self
      def all_steps
        %i[outgoings partner_outgoings property property_landlord cannot_use_service shared_ownership_housing_costs mortgage_or_loan_payment housing_costs property_entry]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.skip_income_questions?(session_data)
          if Steps::Logic.skip_capital_questions?(session_data)
            []
          else
            [
              Steps::Group.new(:property),
              (Steps::Group.new(:property_landlord) if Steps::Logic.owns_property_shared_ownership?(session_data)),
              (Steps::Group.new(:cannot_use_service) if Steps::Logic.landlord_is_not_the_only_joint_owner?(session_data)),
            ].compact
          end
        else
          [
            Steps::Group.new(:outgoings),
            (Steps::Group.new(:partner_outgoings) if Steps::Logic.partner?(session_data)),
            Steps::Group.new(:property),
            (Steps::Group.new(:property_landlord) if Steps::Logic.owns_property_shared_ownership?(session_data)),
            (Steps::Group.new(:cannot_use_service) if Steps::Logic.landlord_is_not_the_only_joint_owner?(session_data)),
            housing_costs_group(session_data),
          ].compact
        end
      end

      def housing_costs_group(session_data)
        # step = if session_data["property_owned"] == "shared_ownership"
        #          :shared_ownership_housing_costs
        #        elsif Steps::Logic.owns_property_with_mortgage_or_loan?(session_data)
        #          :mortgage_or_loan_payment
        #        elsif !Steps::Logic.owns_property_outright?(session_data)
        #          :housing_costs
        #        end
        # Steps::Group.new(step) if step
        steps = if session_data["property_owned"] == "shared_ownership"
                  # the line below ensures that this test passes
                  # spec/flows/shared_ownership_flow_spec.rb
                  # %i[shared_ownership_housing_costs]
                  # the line below ensures that this test passes
                  # spec/flows/change_answers_flow_spec.rb:123
                  %i[shared_ownership_housing_costs property_entry]
                  # cant have both lines so how to fix this as property_entry is required across 2 sections
                elsif Steps::Logic.owns_property_with_mortgage_or_loan?(session_data)
                  [:mortgage_or_loan_payment]
                elsif !Steps::Logic.owns_property_outright?(session_data)
                  [:housing_costs]
                end
        Steps::Group.new(*steps) if steps
      end
    end
  end
end
