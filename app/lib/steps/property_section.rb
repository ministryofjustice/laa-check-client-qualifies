module Steps
  class PropertySection
    PROPERTY_STEPS = %i[property property_entry].freeze
    ADDITIONAL_PROPERTY_STEPS = %i[additional_property additional_property_details].freeze
    ADDITIONAL_PARTNER_PROPERTY_STEPS = %i[partner_additional_property partner_additional_property_details].freeze

    class << self
      def all_steps
        PROPERTY_STEPS + ADDITIONAL_PROPERTY_STEPS + ADDITIONAL_PARTNER_PROPERTY_STEPS
      end

      def grouped_steps_for(session_data)
        return [] unless FeatureFlags.enabled?(:household_section)
        return [] if Steps::Logic.asylum_supported?(session_data)

        [
          Steps::Group.new(*property_steps(session_data)),
          Steps::Group.new(*additional_property_steps(session_data)),
          partner_additional_property_group(session_data),
        ].compact
      end

      def property_steps(session_data)
        Steps::Logic.owns_property?(session_data) ? PROPERTY_STEPS : %i[property]
      end

      def additional_property_steps(session_data)
        Steps::Logic.owns_additional_property?(session_data) ? ADDITIONAL_PROPERTY_STEPS : %i[additional_property]
      end

      def partner_additional_property_group(session_data)
        return unless Steps::Logic.partner?(session_data)

        steps = if Steps::Logic.partner_owns_additional_property?(session_data)
                  ADDITIONAL_PARTNER_PROPERTY_STEPS
                else
                  %i[partner_additional_property]
                end
        Steps::Group.new(*steps)
      end
    end
  end
end
