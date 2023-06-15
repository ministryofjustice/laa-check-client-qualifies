module Steps
  class PartnerSection
    class << self
      def all_steps
        %i[partner_details
           partner_employment_status
           partner_employment
           partner_benefits
           partner_benefit_details
           partner_other_income
           partner_outgoings]
      end

      def grouped_steps_for(session_data)
        if !Steps::Logic.partner?(session_data)
          []
        elsif Steps::Logic.passported?(session_data)
          [Steps::Group.new(:partner_details)]
        else
          [Steps::Group.new(:partner_details),
           employment_status_step,
           employment_steps(session_data),
           benefit_steps(session_data),
           Steps::Group.new(:partner_other_income)].compact
        end
      end

    private

      def employment_status_step
        Steps::Group.new(:partner_employment_status) if FeatureFlags.enabled?(:self_employed)
      end

      def employment_steps(session_data)
        Steps::Group.new(:partner_employment) if Steps::Logic.partner_employed?(session_data)
      end

      def benefit_steps(session_data)
        steps = if Steps::Logic.partner_benefits?(session_data)
                  %i[partner_benefits partner_benefit_details]
                else
                  %i[partner_benefits]
                end
        Steps::Group.new(*steps)
      end
    end
  end
end
