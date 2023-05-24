module Steps
  class PartnerSection
    class << self
      def all_steps
        %i[partner_details partner_dependant_details]
      end

      def all_steps_for_current_feature_flags
        return %i[partner_details] if FeatureFlags.enabled?(:household_section)

        all_steps
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.partner?(session_data)
          []
        else
          [
            Steps::Group.new(:partner_details),
            dependants(session_data),
          ].compact
        end
      end

      def dependants(session_data)
        return if Steps::Logic.passported?(session_data)
        return if FeatureFlags.enabled?(:household_section)

        Steps::Group.new(:partner_dependant_details)
      end
    end
  end
end
