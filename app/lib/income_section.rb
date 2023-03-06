class IncomeSection
  class << self
    def all_steps
      %i[employment
         benefits
         other_income
         partner_details
         partner_employment
         partner_benefits
         partner_other_income
         dependant_details
         outgoings
         partner_outgoings
         housing]
    end

    def steps_for(estimate)
      return [] if estimate.asylum_support_and_upper_tribunal?

      if estimate.passporting
        if estimate.partner
          [[:partner_details]]
        else
          []
        end
      else
        client_income_steps(estimate) + partner_income_steps(estimate) + dependant_details_steps + outgoings_steps(estimate)
      end
    end

  private

    def client_income_steps(estimate)
      return %i[employment benefits other_income].map { [_1] } if estimate.employed

      %i[benefits other_income].map { [_1] }
    end

    def partner_income_steps(estimate)
      return [] unless estimate.partner
      return %i[partner_details partner_employment partner_benefits partner_other_income].map { [_1] } if estimate.partner_employed

      %i[partner_details partner_benefits partner_other_income].map { [_1] }
    end

    def outgoings_steps(estimate)
      return %i[outgoings partner_outgoings housing].map { [_1] } if estimate.partner

      %i[outgoings housing].map { [_1] }
    end

    def dependant_details_steps
      [[:dependant_details]]
    end
  end
end
