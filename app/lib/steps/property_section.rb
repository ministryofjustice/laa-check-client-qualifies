module Steps
  class PropertySection
    PROPERTY_STEPS = %i[property property_entry].freeze

    class << self
      def all_steps
        PROPERTY_STEPS
      end

      def grouped_steps_for(session_data)
        return [] unless FeatureFlags.enabled?(:household_section)
        return [] if Steps::Logic.asylum_supported?(session_data)

        [Steps::Group.new(*property_steps(session_data))]
      end

      def property_steps(session_data)
        Steps::Logic.owns_property?(session_data) ? PROPERTY_STEPS : %i[property]
      end
    end
  end
end
