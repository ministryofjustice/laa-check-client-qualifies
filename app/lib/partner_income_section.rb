class PartnerIncomeSection
  class << self
    def all_steps
      %i[partner_employment partner_benefits partner_other_income partner_outgoings]
    end

    def steps_for(estimate)
      if estimate.passporting || !estimate.partner || estimate.asylum_support_and_upper_tribunal?
        []
      else
        employment_steps(estimate) + other_steps
      end
    end

  private

    def employment_steps(estimate)
      estimate.partner_employed ? [[:partner_employment]] : []
    end

    def other_steps
      %i[partner_benefits partner_other_income partner_outgoings].map { [_1] }
    end
  end
end
