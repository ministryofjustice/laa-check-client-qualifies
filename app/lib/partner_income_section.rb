class PartnerIncomeSection
  class << self
    def all_steps
      %i[partner_employment partner_housing_benefit partner_housing_benefit_details partner_benefits partner_other_income partner_outgoings]
    end

    def steps_for(estimate)
      if estimate.passporting || !estimate.partner || estimate.asylum_support
        []
      else
        employment_steps(estimate) + housing_benefit_steps(estimate) + other_steps
      end
    end

  private

    def employment_steps(estimate)
      estimate.partner_employed ? [[:partner_employment]] : []
    end

    def other_steps
      %i[partner_benefits partner_other_income partner_outgoings].map { [_1] }
    end

    def housing_benefit_steps(estimate)
      estimate.partner_housing_benefit ? [%i[partner_housing_benefit partner_housing_benefit_details]] : [%i[partner_housing_benefit]]
    end
  end
end
