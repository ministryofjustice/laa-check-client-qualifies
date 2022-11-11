class PartnerIncomeSection
  class << self
    def all_steps
      %i[partner_employment partner_benefits partner_other_income partner_outgoings]
    end

    def steps_for(estimate)
      if estimate.passporting || !estimate.partner
        []
      else
        employment_step = estimate.partner_employed ? [:partner_employment] : []
        (employment_step + %i[partner_benefits partner_other_income partner_outgoings]).map { [_1] }
      end
    end
  end
end
