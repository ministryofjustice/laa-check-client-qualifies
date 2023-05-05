module Steps
  class PartnerIncomeSection
    class << self
      def all_steps
        %i[partner_employment partner_housing_benefit partner_housing_benefit_details partner_benefits partner_benefit_details partner_other_income partner_outgoings]
      end

      def grouped_steps_for(session_data)
        if Steps::Logic.passported?(session_data) || !Steps::Logic.partner?(session_data)
          []
        else
          [employment_steps(session_data),
           housing_benefit_steps(session_data),
           benefit_steps(session_data),
           Steps::Group.new(:partner_other_income),
           Steps::Group.new(:partner_outgoings)].compact
        end
      end

    private

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

      def housing_benefit_steps(session_data)
        steps = if Steps::Logic.partner_housing_benefit?(session_data)
                  %i[partner_housing_benefit partner_housing_benefit_details]
                else
                  %i[partner_housing_benefit]
                end
        Steps::Group.new(*steps)
      end
    end
  end
end
