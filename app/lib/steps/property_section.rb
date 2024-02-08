module Steps
  class PropertySection
    PROPERTY_STEPS = %i[property property_entry].freeze
    ADDITIONAL_PROPERTY_STEPS = %i[additional_property additional_property_details].freeze
    ADDITIONAL_PARTNER_PROPERTY_STEPS = %i[partner_additional_property partner_additional_property_details].freeze
    HOUSING_COSTS_STEPS = %i[housing_costs mortgage_or_loan_payment].freeze

    class << self
      def all_steps
        PROPERTY_STEPS + ADDITIONAL_PROPERTY_STEPS + ADDITIONAL_PARTNER_PROPERTY_STEPS + HOUSING_COSTS_STEPS
      end

      def grouped_steps_for(session_data)
        logic = Steps::Logic::Thing.new(session_data)

        return [] if logic.skip_capital_questions?

        if FeatureFlags.enabled?(:outgoings_flow, session_data)
          [
            (Steps::Group.new(:property_entry) if logic.owns_property?),
            Steps::Group.new(*additional_property_steps(logic)),
            partner_additional_property_group(logic),
          ].compact
        else
          [
            Steps::Group.new(*property_steps(logic)),
            (Steps::OutgoingsSection.housing_costs_group(logic) unless logic.passported?),
            Steps::Group.new(*additional_property_steps(logic)),
            partner_additional_property_group(logic),
          ].compact
        end
      end

      def property_steps(logic)
        logic.owns_property? ? PROPERTY_STEPS : %i[property]
      end

      def additional_property_steps(logic)
        logic.owns_additional_property? ? ADDITIONAL_PROPERTY_STEPS : %i[additional_property]
      end

      def partner_additional_property_group(logic)
        return unless logic.partner?

        steps = if logic.partner_owns_additional_property?
                  ADDITIONAL_PARTNER_PROPERTY_STEPS
                else
                  %i[partner_additional_property]
                end
        Steps::Group.new(*steps)
      end
    end
  end
end
