module Steps
  class PartnerSection
    class << self
      def all_steps
        %i[partner_details
           partner_employment_status
           partner_income
           partner_benefits
           partner_benefit_details
           partner_other_income]
      end

      def grouped_steps_for(session_data)
        logic = Steps::Logic::Thing.new(session_data)
        if !logic.partner?
          []
        elsif logic.passported?
          [Steps::Group.new(:partner_details)]
        else
          [Steps::Group.new(:partner_details),
           Steps::Group.new(:partner_employment_status),
           employment_steps(logic),
           benefit_steps(logic),
           Steps::Group.new(:partner_other_income)].compact
        end
      end

    private

      def employment_steps(logic)
        Steps::Group.new(:partner_income) if logic.partner_employed?
      end

      def benefit_steps(logic)
        steps = if logic.partner_benefits?
                  %i[partner_benefits partner_benefit_details]
                else
                  %i[partner_benefits]
                end
        Steps::Group.new(*steps)
      end
    end
  end
end
