module Steps
  class PartnerCapitalSection
    PROPERTY_STEPS = %i[partner_property partner_property_entry].freeze
    VEHICLE_STEPS = %i[partner_vehicle partner_vehicle_details].freeze
    TAIL_STEPS = %i[partner_assets].freeze

    class << self
      def all_steps
        (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.partner?(session_data)
          []
        else
          [property_steps(session_data),
           vehicle_steps(session_data),
           Steps::Group.new(:partner_assets)].compact
        end
      end

      def property_steps(session_data)
        return if FeatureFlags.enabled?(:household_section)
        return if Steps::Logic.owns_property?(session_data)

        if Steps::Logic.partner_owns_property?(session_data)
          Steps::Group.new(*PROPERTY_STEPS)
        else
          Steps::Group.new(:partner_property)
        end
      end

      def vehicle_steps(session_data)
        return if Steps::Logic.controlled?(session_data) || FeatureFlags.enabled?(:household_section)

        Steps::Group.new(*(Steps::Logic.partner_owns_vehicle?(session_data) ? VEHICLE_STEPS : %i[partner_vehicle]))
      end
    end
  end
end
