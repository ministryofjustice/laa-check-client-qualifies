module Steps
  class ApplicantDetailsSection
    class << self
      def all_steps
        %i[applicant dependant_details]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.asylum_supported?(session_data)
          []
        else
          steps(session_data).map { Steps::Group.new(_1) }
        end
      end

      def steps(session_data)
        [:applicant, dependant_details(session_data)].compact
      end

      def dependant_details(session_data)
        :dependant_details unless Steps::Logic.passported?(session_data)
      end
    end
  end
end
