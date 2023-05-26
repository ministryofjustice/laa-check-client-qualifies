module Steps
  class ApplicantDetailsSection
    class << self
      def all_steps
        %i[applicant dependant_details partner_details]
      end

      def all_steps_for_current_feature_flags
        all_steps
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.asylum_supported?(session_data)
          []
        else
          groups(session_data).map { Steps::Group.new(_1) }
        end
      end

      def groups(session_data)
        [:applicant, dependant_details(session_data), partner_details(session_data)].compact
      end

      def dependant_details(session_data)
        :dependant_details unless Steps::Logic.passported?(session_data)
      end

      def partner_details(session_data)
        return unless Steps::Logic.partner?(session_data)

        :partner_details if Steps::Logic.passported?(session_data) && FeatureFlags.enabled?(:household_section)
      end
    end
  end
end
