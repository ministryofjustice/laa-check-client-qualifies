module Steps
  class CapitalSection
    PROPERTY_STEPS = %i[property property_entry].freeze
    VEHICLE_STEPS = %i[vehicle vehicle_details vehicles_details].freeze
    TAIL_STEPS = %i[assets].freeze

    class << self
      def all_steps
        (PROPERTY_STEPS + VEHICLE_STEPS + TAIL_STEPS).freeze
      end

      def grouped_steps_for(session_data)
        return [] if Steps::Logic.asylum_supported?(session_data)

        [property_steps(session_data),
         vehicle_steps(session_data),
         Steps::Group.new(*TAIL_STEPS)].compact
      end

      def property_steps(session_data)
        return if FeatureFlags.enabled?(:household_section)

        Steps::Group.new(*(Steps::Logic.owns_property?(session_data) ? PROPERTY_STEPS : %i[property]))
      end

      def vehicle_steps(session_data)
        return if Steps::Logic.controlled?(session_data)

        steps = Steps::Logic.owns_vehicle?(session_data) ? [:vehicle, second_vehicle_screen] : %i[vehicle]
        Steps::Group.new(*steps)
      end

      def second_vehicle_screen
        FeatureFlags.enabled?(:household_section) ? :vehicles_details : :vehicle_details
      end
    end
  end
end
