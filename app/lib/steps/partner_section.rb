module Steps
  class PartnerSection
    class << self
      def all_steps
        %i[partner_details partner_dependant_details]
      end

      def all_steps_for_current_feature_flags
        all_steps
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.partner?(session_data)
          []
        else
          [
            Steps::Group.new(:partner_details),
            (Steps::Group.new(:partner_dependant_details) unless Steps::Logic.passported?(session_data)),
          ].compact
        end
      end
    end
  end
end
