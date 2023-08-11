module Steps
  class ApplicantDetailsSection
    class << self
      def all_steps
        %i[applicant dependant_details dependant_income dependant_income_details]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.asylum_supported?(session_data)
          []
        else
          groups(session_data).map { Steps::Group.new(*_1) }
        end
      end

      def groups(session_data)
        [[:applicant], dependant_details(session_data)].compact
      end

      def dependant_details(session_data)
        return if Steps::Logic.passported?(session_data)

        [:dependant_details, dependant_income(session_data)].flatten.compact
      end

      def dependant_income(session_data)
        return unless Steps::Logic.dependants?(session_data)

        [:dependant_income, dependant_income_details(session_data)]
      end

      def dependant_income_details(session_data)
        :dependant_income_details if Steps::Logic.dependants_get_income?(session_data)
      end
    end
  end
end
